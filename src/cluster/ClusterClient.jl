# This file is a part of TypeDBClient.  License is MIT: https://github.com/Humans-of-Julia/TypeDBClient.jl/blob/main/LICENSE 

# 
# package typedb.client.cluster;
# 
# import typedb.client.api.TypeDBClient;
# import typedb.client.api.TypeDBOptions;
# import typedb.client.api.TypeDBSession;
# import typedb.client.common.exception.TypeDBClientException;
# import typedb.client.common.rpc.TypeDBStub;
# import typedb.client.core.CoreClient;
# import typedb.common.collection.Pair;
# import typedb.protocol.ClusterServerProto;
# import io.grpc.StatusRuntimeException;
# import org.slf4j.Logger;
# import org.slf4j.LoggerFactory;
# 
# import java.util.Map;
# import java.util.Set;
# import java.util.concurrent.ConcurrentHashMap;
# import java.util.concurrent.ConcurrentMap;
# 
# import static typedb.client.common.exception.ErrorMessage.Client.CLUSTER_UNABLE_TO_CONNECT;
# import static typedb.client.common.rpc.RequestBuilder.Cluster.Server.allReq;
# import static typedb.common.collection.Collections.pair;
# import static java.util.stream.Collectors.toMap;
# import static java.util.stream.Collectors.toSet;
# 
# public class ClusterClient implements TypeDBClient.Cluster {
# 
#     private static final Logger LOG = LoggerFactory.getLogger(ClusterClient.class);
#     private final Map<String, CoreClient> coreClients;
#     private final Map<String, TypeDBStub.Cluster> stubs;
#     private final ClusterDatabaseManager databaseMgrs;
#     private final ConcurrentMap<String, ClusterDatabase> clusterDatabases;
#     private boolean isOpen;
# 
#     public ClusterClient(Set<String> addresses) {
#         this(addresses, CoreClient.calculateParallelisation());
#     }
# 
#     public ClusterClient(Set<String> addresses, int parallelisation) {
#         coreClients = fetchServerAddresses(addresses).stream()
#                 .map(address -> pair(address, new CoreClient(address, parallelisation)))
#                 .collect(toMap(Pair::first, Pair::second));
#         stubs = coreClients.entrySet().stream()
#                 .map(client -> pair(client.getKey(), TypeDBStub.cluster(client.getValue().channel())))
#                 .collect(toMap(Pair::first, Pair::second));
#         databaseMgrs = new ClusterDatabaseManager(this);
#         clusterDatabases = new ConcurrentHashMap<>();
#         isOpen = true;
#     }
# 
#     private Set<String> fetchServerAddresses(Set<String> addresses) {
#         for (String address : addresses) {
#             try (CoreClient client = new CoreClient(address)) {
#                 LOG.debug("Fetching list of cluster servers from {}...", address);
#                 TypeDBStub.Cluster stub = TypeDBStub.cluster(client.channel());
#                 ClusterServerProto.ServerManager.All.Res res = stub.serversAll(allReq());
#                 Set<String> members = res.getServersList().stream().map(ClusterServerProto.Server::getAddress).collect(toSet());
#                 LOG.debug("The cluster servers are {}", members);
#                 return members;
#             } catch (StatusRuntimeException e) {
#                 LOG.error("Fetching cluster servers from {} failed.", address);
#             }
#         }
#         throw new TypeDBClientException(CLUSTER_UNABLE_TO_CONNECT, String.join(",", addresses));
#     }
# 
#     @Override
#     public boolean isOpen() {
#         return isOpen;
#     }
# 
#     @Override
#     public ClusterDatabaseManager databases() {
#         return databaseMgrs;
#     }
# 
#     @Override
#     public ClusterSession session(String database, TypeDBSession.Type type) {
#         return session(database, type, TypeDBOptions.cluster());
#     }
# 
#     @Override
#     public ClusterSession session(String database, TypeDBSession.Type type, TypeDBOptions options) {
#         TypeDBOptions.Cluster clusterOptions = options.asCluster();
#         if (clusterOptions.readAnyReplica().isPresent() && clusterOptions.readAnyReplica().get()) {
#             return sessionAnyReplica(database, type, clusterOptions);
#         } else {
#             return sessionPrimaryReplica(database, type, clusterOptions);
#         }
#     }
# 
#     private ClusterSession sessionPrimaryReplica(String database, TypeDBSession.Type type, TypeDBOptions.Cluster options) {
#         return openSessionFailsafeTask(database, type, options, this).runPrimaryReplica();
#     }
# 
#     private ClusterSession sessionAnyReplica(String database, TypeDBSession.Type type, TypeDBOptions.Cluster options) {
#         return openSessionFailsafeTask(database, type, options, this).runAnyReplica();
#     }
# 
#     private FailsafeTask<ClusterSession> openSessionFailsafeTask(
#             String database, TypeDBSession.Type type, TypeDBOptions.Cluster options, ClusterClient client) {
#         return new FailsafeTask<ClusterSession>(this, database) {
#             @Override
#             ClusterSession run(ClusterDatabase.Replica replica) {
#                 return new ClusterSession(client, replica.address(), database, type, options);
#             }
#         };
#     }
# 
#     // TODO: this is not good - we should not pass an internal object to be modified outside of this class
#     ConcurrentMap<String, ClusterDatabase> databaseByName() {
#         return clusterDatabases;
#     }
# 
#     Map<String, CoreClient> coreClients() {
#         return coreClients;
#     }
# 
#     Set<String> clusterMembers() {
#         return coreClients.keySet();
#     }
# 
#     CoreClient coreClient(String address) {
#         return coreClients.get(address);
#     }
# 
#     TypeDBStub.Cluster stub(String address) {
#         return stubs.get(address);
#     }
# 
#     @Override
#     public boolean isCluster() {
#         return true;
#     }
# 
#     @Override
#     public Cluster asCluster() {
#         return this;
#     }
# 
#     @Override
#     public void close() {
#         coreClients.values().forEach(CoreClient::close);
#         isOpen = false;
#     }
# }
