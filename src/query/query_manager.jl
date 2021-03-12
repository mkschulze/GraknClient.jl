# This file is a part of GraknClient.  License is MIT: https://github.com/Humans-of-Julia/GraknClient.jl/blob/main/LICENSE

struct QueryManager <: AbstractQueryManager
    _transaction::Union{T,Nothing} where {T<:AbstractTransaction}
end

QueryManager() = QueryManager(nothing)


# function match(querMan::T, query::String, options::GraknOptions = nothing) where {T<:AbstractQueryManager}
#     if !options
#         options = core()
#     end
#     request = grakn.protocol.Query_Req()
#     match_req =grakn.protocol.Query_Match_Req()
#     match_req.query = query
#     request.match_req = match_req
#     return map(lambda answer_proto: concept_map._of(answer_proto), self._iterate_query(request, lambda res: res.query_res.match_res.answers, options))
# end


#     def match_aggregate(self, query: str, options: GraknOptions = None):
#         if not options:
#             options = GraknOptions.core()
#         request = query_proto.Query.Req()
#         match_aggregate_req = query_proto.Query.MatchAggregate.Req()
#         match_aggregate_req.query = query
#         request.match_aggregate_req.CopyFrom(match_aggregate_req)
#         return self._iterate_query(request, lambda res: [numeric._of(res.query_res.match_aggregate_res.answer)], options)

#     def match_group(self, query: str, options: GraknOptions = None):
#         if not options:
#             options = GraknOptions.core()
#         request = query_proto.Query.Req()
#         match_group_req = query_proto.Query.MatchGroup.Req()
#         match_group_req.query = query
#         request.match_group_req.CopyFrom(match_group_req)
#         return map(
#             lambda cmg_proto: concept_map_group._of(cmg_proto),
#             self._iterate_query(request, lambda res: res.query_res.match_group_res.answers, options)
#         )

#     def match_group_aggregate(self, query: str, options: GraknOptions = None):
#         if not options:
#             options = GraknOptions.core()
#         request = query_proto.Query.Req()
#         match_group_aggregate_req = query_proto.Query.MatchGroupAggregate.Req()
#         match_group_aggregate_req.query = query
#         request.match_group_aggregate_req.CopyFrom(match_group_aggregate_req)
#         return map(
#             lambda numeric_group_proto: numeric_group._of(numeric_group_proto),
#             self._iterate_query(request, lambda res: res.query_res.match_group_aggregate_res.answers, options)
#         )

#     def insert(self, query: str, options: GraknOptions = None):
#         if not options:
#             options = GraknOptions.core()
#         request = query_proto.Query.Req()
#         insert_req = query_proto.Query.Insert.Req()
#         insert_req.query = query
#         request.insert_req.CopyFrom(insert_req)
#         return map(lambda answer_proto: concept_map._of(answer_proto), self._iterate_query(request, lambda res: res.query_res.insert_res.answers, options))

#     def delete(self, query: str, options: GraknOptions = None):
#         if not options:
#             options = GraknOptions.core()
#         request = query_proto.Query.Req()
#         delete_req = query_proto.Query.Delete.Req()
#         delete_req.query = query
#         request.delete_req.CopyFrom(delete_req)
#         return self._iterate_query(request, lambda res: [], options)

#     def update(self, query: str, options: GraknOptions = None):
#         if not options:
#             options = GraknOptions.core()
#         request = query_proto.Query.Req()
#         update_req = query_proto.Query.Update.Req()
#         update_req.query = query
#         request.update_req.CopyFrom(update_req)
#         return map(lambda answer_proto: concept_map._of(answer_proto), self._iterate_query(request, lambda res: res.query_res.update_res.answers, options))

#     def define(self, query: str, options: GraknOptions = None):
#         if not options:
#             options = GraknOptions.core()
#         request = query_proto.Query.Req()
#         define_req = query_proto.Query.Define.Req()
#         define_req.query = query
#         request.define_req.CopyFrom(define_req)
#         return self._iterate_query(request, lambda res: [], options)

#     def undefine(self, query: str, options: GraknOptions = None):
#         if not options:
#             options = GraknOptions.core()
#         request = query_proto.Query.Req()
#         undefine_req = query_proto.Query.Undefine.Req()
#         undefine_req.query = query
#         request.undefine_req.CopyFrom(undefine_req)
#         return self._iterate_query(request, lambda res: [], options)

#     def _iterate_query(self, query_req: query_proto.Query.Req, response_reader: Callable[[transaction_proto.Transaction.Res], List], options: GraknOptions):
#         req = transaction_proto.Transaction.Req()
#         query_req.options.CopyFrom(grakn_proto_builder.options(options))
#         req.query_req.CopyFrom(query_req)
#         return self._transaction._stream(req, response_reader)