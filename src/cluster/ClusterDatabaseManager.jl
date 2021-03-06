# This file is a part of TypeDBClient.  License is MIT: https://github.com/Humans-of-Julia/TypeDBClient.jl/blob/main/LICENSE 

# 
# package typedb.client.cluster;
# 
# import typedb.client.api.database.Database;
# import typedb.client.api.database.DatabaseManager;
# import typedb.client.common.exception.TypeDBClientException;
# import typedb.client.core.CoreDatabaseManager;
# import typedb.common.collection.Pair;
# import typedb.protocol.ClusterDatabaseProto;
# 
# import java.util.List;
# import java.util.Map;
# 
# import static typedb.client.common.exception.ErrorMessage.Client.CLUSTER_ALL_NODES_FAILED;
# import static typedb.client.common.rpc.RequestBuilder.Cluster.DatabaseManager.allReq;
# import static typedb.client.common.rpc.RequestBuilder.Cluster.DatabaseManager.getReq;
# import static typedb.common.collection.Collections.pair;
# import static java.util.stream.Collectors.toList;
# import static java.util.stream.Collectors.toMap;
# 
# public class ClusterDatabaseManager implements DatabaseManager.Cluster {
#     private final Map<String, CoreDatabaseManager> databaseMgrs;
#     private final ClusterClient client;
# 
#     public ClusterDatabaseManager(ClusterClient client) {
#         this.client = client;
#         this.databaseMgrs = client.coreClients().entrySet().stream()
#                 .map(c -> pair(c.getKey(), c.getValue().databases()))
#                 .collect(toMap(Pair::first, Pair::second));
#         ;
#     }
# 
#     @Override
#     public boolean contains(String name) {
#         StringBuilder errors = new StringBuilder();
#         for (String address : databaseMgrs.keySet()) {
#             try {
#                 return databaseMgrs.get(address).contains(name);
#             } catch (TypeDBClientException e) {
#                 errors.append("- ").append(address).append(": ").append(e).append("\n");
#             }
#         }
#         throw new TypeDBClientException(CLUSTER_ALL_NODES_FAILED, errors.toString());
#     }
# 
#     @Override
#     public void create(String name) {
#         for (CoreDatabaseManager databaseMgr : databaseMgrs.values()) {
#             if (!databaseMgr.contains(name)) {
#                 databaseMgr.create(name);
#             }
#         }
#     }
# 
#     @Override
#     public Database.Cluster get(String name) {
#         StringBuilder errors = new StringBuilder();
#         for (String address : databaseMgrs.keySet()) {
#             try {
#                 ClusterDatabaseProto.ClusterDatabaseManager.Get.Res res = client.stub(address).databasesGet(getReq(name));
#                 return ClusterDatabase.of(res.getDatabase(), this);
#             } catch (TypeDBClientException e) {
#                 errors.append("- ").append(address).append(": ").append(e).append("\n");
#             }
#         }
#         throw new TypeDBClientException(CLUSTER_ALL_NODES_FAILED, errors.toString());
#     }
# 
#     @Override
#     public List<Database.Cluster> all() {
#         StringBuilder errors = new StringBuilder();
#         for (String address : databaseMgrs.keySet()) {
#             try {
#                 ClusterDatabaseProto.ClusterDatabaseManager.All.Res res = client.stub(address).databasesAll(allReq());
#                 return res.getDatabasesList().stream().map(db -> ClusterDatabase.of(db, this)).collect(toList());
#             } catch (TypeDBClientException e) {
#                 errors.append("- ").append(address).append(": ").append(e).append("\n");
#             }
#         }
#         throw new TypeDBClientException(CLUSTER_ALL_NODES_FAILED, errors.toString());
#     }
# 
#     Map<String, CoreDatabaseManager> databaseMgrs() {
#         return databaseMgrs;
#     }
# }
