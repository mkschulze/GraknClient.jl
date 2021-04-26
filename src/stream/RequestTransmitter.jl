# This file is a part of TypeDBClient.  License is MIT: https://github.com/Humans-of-Julia/TypeDBClient.jl/blob/main/LICENSE

const BATCH_WINDOW_SMALL_MILLIS = 1
const BATCH_WINDOW_LARGE_MILLIS = 3

mutable struct Dispatcher
    input_channel::Channel{Proto.Transaction_Client}
    direct_dispatch_channel::Channel{Proto.ProtoType}
    dispatch_channel::Channel{Proto.ProtoType}
    dispatch_timer::Optional{Timer}
end


function Dispatcher(input_channel::Channel{Proto.Transaction_Client})
    direct_dispatch_channel = Channel{Proto.ProtoType}(10)
    dispatch_channel = Channel{Proto.ProtoType}(10)
    disp_timer = batch_requests(dispatch_channel,input_channel)
    process_direct_requests(direct_dispatch_channel, input_channel)

    return Dispatcher(input_channel, direct_dispatch_channel, dispatch_channel,disp_timer)
end

"""
function process_direct_requests(in_channel::Channel{Proto.ProtoType}, out_channel::Channel{Proto.Transaction_Client})
    This function process the incoming request directly to the server
"""
function process_direct_requests(in_channel::Channel{Proto.ProtoType}, out_channel::Channel{Proto.Transaction_Client})
    @async begin
        while isopen(in_channel)
            yield()
            # if the grpc connection shows an error or is terminated for the channel
            # the loop will exited
            try
                if isready(in_channel)
                    tmp_res = take!(in_channel)
                    client_res = TransactionRequestBuilder.client_msg([tmp_res])
                    Threads.@spawn put!(out_channel,client_res)
                end
            catch ex
                @info "process_direct_requests shows an error"
            finally
            end
        end
        @info "process_direct_requests was closed"
    end
end

"""
function batch_requests(in_channel::Channel{Proto.ProtoType}, out_channel::Channel{Proto.Transaction_Client})
    This function contains the whole logic for batching incomming requests. The inner runner function will be
    called every x ms and will send the collected request in one Transaction_Client message to teh server.
"""
function batch_requests(in_channel::Channel{Proto.ProtoType}, out_channel::Channel{Proto.Transaction_Client})
    time_to_run = BATCH_WINDOW_SMALL_MILLIS / 1000

    function runner(controller)
        @async sleeper(controller)
        answers = Proto.Transaction_Req[]
        try
            while controller.running
                yield()
                if isready(in_channel)
                    tmp_res = take!(in_channel)
                    push!(answers, tmp_res)
                end
            end
            if length(answers) > 0
                put!(out_channel, TransactionRequestBuilder.client_msg(answers))
            end
        catch ex
            throw(TypeDBClientException("batch_requests runner failure",ex))
        end
    end

    cb(timer) = (runner(Controller(true, time_to_run)))
    t = Timer(cb,time_to_run, interval = time_to_run)
    wait(t)

    return t
end

function close(dispatcher::Dispatcher)
    close(dispatcher.direct_dispatch_channel)
    close(dispatcher.dispatch_channel)
    close(dispatcher.dispatch_timer)
    return true
end

#
# package typedb.client.stream;
#
# import typedb.client.common.exception.TypeDBClientException;
# import typedb.client.common.rpc.RequestBuilder;
# import typedb.common.collection.ConcurrentSet;
# import typedb.common.concurrent.NamedThreadFactory;
# import typedb.protocol.TransactionProto;
# import io.grpc.stub.StreamObserver;
# import org.slf4j.Logger;
# import org.slf4j.LoggerFactory;
#
# import java.util.ArrayList;
# import java.util.concurrent.ConcurrentLinkedQueue;
# import java.util.concurrent.Semaphore;
# import java.util.concurrent.ThreadFactory;
# import java.util.concurrent.atomic.AtomicBoolean;
# import java.util.concurrent.atomic.AtomicInteger;
# import java.util.concurrent.locks.ReadWriteLock;
# import java.util.concurrent.locks.StampedLock;
#
# import static typedb.client.common.exception.ErrorMessage.Client.CLIENT_CLOSED;
#
# public class RequestTransmitter implements AutoCloseable {
#
#     private static final Logger LOG = LoggerFactory.getLogger(RequestTransmitter.class);
#     private static final int BATCH_WINDOW_SMALL_MILLIS = 1;
#     private static final int BATCH_WINDOW_LARGE_MILLIS = 3;
#
#     private final ArrayList<Executor> executors;
#     private final AtomicInteger executorIndex;
#     private final ReadWriteLock accessLock;
#     private volatile boolean isOpen;
#
#     public RequestTransmitter(int parallelisation, NamedThreadFactory threadFactory) {
#         this.executors = new ArrayList<>(parallelisation);
#         this.executorIndex = new AtomicInteger(0);
#         this.accessLock = new StampedLock().asReadWriteLock();
#         this.isOpen = true;
#         for (int i = 0; i < parallelisation; i++) this.executors.add(new Executor(threadFactory));
#     }
#
#     private Executor nextExecutor() {
#         return executors.get(executorIndex.getAndUpdate(i -> {
#             i++;
#             if (i % executors.size() == 0) i = 0;
#             return i;
#         }));
#     }
#
#     public Dispatcher dispatcher(StreamObserver<TransactionProto.Transaction.Client> requestObserver) {
#         try {
#             accessLock.readLock().lock();
#             if (!isOpen) throw new TypeDBClientException(CLIENT_CLOSED);
#             Executor executor = nextExecutor();
#             Dispatcher dispatcher = new Dispatcher(executor, requestObserver);
#             executor.dispatchers.add(dispatcher);
#             return dispatcher;
#         } finally {
#             accessLock.readLock().unlock();
#         }
#     }
#
#     @Override
#     public void close() {
#         try {
#             accessLock.writeLock().lock();
#             if (isOpen) {
#                 isOpen = false;
#                 executors.forEach(Executor::close);
#             }
#         } finally {
#             accessLock.writeLock().unlock();
#         }
#     }
#
#     private class Executor implements AutoCloseable {
#
#         private final ConcurrentSet<Dispatcher> dispatchers;
#         private final AtomicBoolean isRunning;
#         private final Semaphore permissionToRun;
#
#         private Executor(ThreadFactory threadFactory) {
#             dispatchers = new ConcurrentSet<>();
#             isRunning = new AtomicBoolean(false);
#             permissionToRun = new Semaphore(0);
#             threadFactory.newThread(this::run).start();
#         }
#
#         private void mayStartRunning() {
#             if (isRunning.compareAndSet(false, true)) permissionToRun.release();
#         }
#
#         private void run() {
#             while (isOpen) {
#                 try {
#                     permissionToRun.acquire();
#                     boolean first = true;
#                     while (true) {
#                         Thread.sleep(first ? BATCH_WINDOW_SMALL_MILLIS : BATCH_WINDOW_LARGE_MILLIS);
#                         if (dispatchers.isEmpty()) break;
#                         else dispatchers.forEach(Dispatcher::sendBatchedRequests);
#                         first = false;
#                     }
#                 } catch (InterruptedException e) {
#                     LOG.error(e.getMessage(), e);
#                 } finally {
#                     isRunning.set(false);
#                 }
#                 if (!dispatchers.isEmpty()) mayStartRunning();
#             }
#         }
#
#         @Override
#         public void close() {
#             dispatchers.forEach(Dispatcher::close);
#             mayStartRunning();
#         }
#     }
#
#     public class Dispatcher implements AutoCloseable {
#
#         private final Executor executor;
#         private final StreamObserver<TransactionProto.Transaction.Client> requestObserver;
#         private final ConcurrentLinkedQueue<TransactionProto.Transaction.Req> requestQueue;
#
#         private Dispatcher(Executor executor, StreamObserver<TransactionProto.Transaction.Client> requestObserver) {
#             this.executor = executor;
#             this.requestObserver = requestObserver;
#             requestQueue = new ConcurrentLinkedQueue<>();
#         }
#
#         private synchronized void sendBatchedRequests() {
#             if (requestQueue.isEmpty() || !isOpen) return;
#             TransactionProto.Transaction.Req request;
#             while ((request = requestQueue.poll()) != null) requests.add(request);
#             requestObserver.onNext(RequestBuilder.Transaction.clientMsg(requests));
#         }
#
#         public void dispatch(TransactionProto.Transaction.Req requestProto) {
#             try {
#                 accessLock.readLock().lock();
#                 if (!isOpen) throw new TypeDBClientException(CLIENT_CLOSED);
#                 requestQueue.add(requestProto);
#                 executor.mayStartRunning();
#             } finally {
#                 accessLock.readLock().unlock();
#             }
#         }
#
#         public void dispatchNow(TransactionProto.Transaction.Req requestProto) {
#             try {
#                 accessLock.readLock().lock();
#                 if (!isOpen) throw new TypeDBClientException(CLIENT_CLOSED);
#                 requestQueue.add(requestProto);
#                 sendBatchedRequests();
#             } finally {
#                 accessLock.readLock().unlock();
#             }
#         }
#
#         @Override
#         public void close() {
#             requestObserver.onCompleted();
#             executor.dispatchers.remove(this);
#         }
#     }
# }
