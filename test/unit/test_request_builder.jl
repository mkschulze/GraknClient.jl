import TypeDBClient.typedb.protocol as Proto
using TypeDBClient: Label, bytes
using UUIDs: uuid4

@testset "RequestBuilder" begin

no_option = Proto.Options()

let b = TypeDBClient.DatabaseManagerRequestBuilder
    @test b.create_req("a").name == "a"
    @test b.contains_req("a").name == "a"
    @test_nowarn b.all_req()
end

let b = TypeDBClient.DatabaseRequestBuilder
    @test b.schema_req("a").name == "a"
    @test b.delete_req("a").name == "a"
end

let b = TypeDBClient.SessionRequestBuilder
    let r = b.open_req("a", Int32(0), no_option)
        @test r.database == "a"
        @test r._type == Int32(0)
        @test r.options == no_option
    end
    @test b.pulse_req([0x01]).session_id == [0x01]
end

let b = TypeDBClient.TransactionRequestBuilder
    let ts = [Proto.Transaction_Req()]
        @test b.client_msg(ts).reqs == ts
    end
    let id = bytes(uuid4()), r = b.stream_req(id)
        @test r.req_id == id
        @test hasproperty(r, :stream_req)
    end
    let id = [0x01], ty = Int32(0), options = no_option, ms = 0,
            r = b.open_req(id, ty, options, ms)
        @test r.open_req.session_id == id
        @test r.open_req._type == ty
        @test r.open_req.options == no_option
        @test r.open_req.network_latency_millis == ms
    end
end

let b = TypeDBClient.QueryManagerRequestBuilder
    for f in (
        :define_req, :undefine_req, :match_req, :match_aggregate_req,
        :match_group_req, :match_group_aggregate_req,
        :insert_req, :delete_req, :update_req,
    )
        func = getfield(b, f)
        let q = func("a").query_manager_req
            underlying_req = getproperty(q, f)
            @test underlying_req.query == "a"
        end
    end
end

let b = TypeDBClient.ConceptManagerRequestBuilder
    @test b.put_entity_type_req("a").concept_manager_req.put_entity_type_req.label == "a"
    @test b.put_relation_type_req("a").concept_manager_req.put_relation_type_req.label == "a"
    @test b.put_attribute_type_req("a", Int32(0)).concept_manager_req.put_attribute_type_req.label == "a"
    @test b.put_attribute_type_req("a", Int32(0)).concept_manager_req.put_attribute_type_req.value_type == Int32(0)
    @test b.get_thing_type_req("a").concept_manager_req.get_thing_type_req.label == "a"
    @test b.get_thing_req("a").concept_manager_req.get_thing_req.iid == bytes("a")
end

let b = TypeDBClient.LogicManagerRequestBuilder
    let r = b.put_rule_req("a", "b", "c")
        @test r.logic_manager_req.put_rule_req.label == "a"
        @test r.logic_manager_req.put_rule_req.when == "b"
        @test r.logic_manager_req.put_rule_req.then == "c"
    end
    @test b.get_rule_req("a").logic_manager_req.get_rule_req.label == "a"
    @test_nowarn b.get_rules_req()
end

# standard labels for testing *type request builders
label = Label("a")
scoped_label = Label("s","a")

let b = TypeDBClient.TypeRequestBuilder

    # For simplicity, conditional scope settting is tested here (`is_abstract_req1)
    # and will be excluded for other tests below.

    let without_scope = b.is_abstract_req(label),
        with_scope = b.is_abstract_req(scoped_label)
        @test without_scope.type_req.label == "a"
        @test hasproperty(without_scope.type_req, :type_is_abstract_req)
        @test !hasproperty(without_scope.type_req, :scope)

        @test with_scope.type_req.scope == "s"
        @test with_scope.type_req.label == "a"
        @test hasproperty(with_scope.type_req, :type_is_abstract_req)
    end

    @test b.set_label_req(label, "b").type_req.type_set_label_req.label == "b"
    @test hasproperty(b.get_supertypes_req(label).type_req, :type_get_supertypes_req)
    @test hasproperty(b.get_subtypes_req(label).type_req, :type_get_subtypes_req)
    @test hasproperty(b.get_supertype_req(label).type_req, :type_get_supertype_req)
    @test hasproperty(b.delete_req(label).type_req, :type_delete_req)
end

let b = TypeDBClient.RoleTypeRequestBuilder

    let r = b.proto_role_type(scoped_label, Proto.Type_Encoding.THING_TYPE)
        @test r.label == "a"
        @test r.encoding == Proto.Type_Encoding.THING_TYPE
    end

    # test assertion for scope requirement
    @test_throws AssertionError b.proto_role_type(label, Proto.Type_Encoding.THING_TYPE)

    @test hasproperty(b.get_relation_types_req(label).type_req, :role_type_get_relation_types_req)
    @test hasproperty(b.get_players_req(label).type_req, :role_type_get_players_req)
end

@testset "ThingRequestBuilder" begin
    let b = TypeDBClient.ThingRequestBuilder
        id_bytes = bytes(uuid4())
        prot_thing = b.proto_thing(id_bytes)
        @test typeof(prot_thing) == Proto.Thing
        @test prot_thing.iid == id_bytes

        prot_thing = b.proto_thing(string(id_bytes))
        @test typeof(prot_thing) == Proto.Thing
        @test prot_thing.iid == id_bytes

        thing_req = b._thing_req(string(id_bytes))
        @test typeof(thing_req) == Proto.Transaction_Req
        @test thing_req.thing_req.iid == id_bytes

        infered = is_inferred_req(string(id_bytes))
    end
end

# TODO Need to continue developing unit tests for these
# module ThingTypeRequestBuilder
# module EntityTypeRequestBuilder
# module RelationTypeRequestBuilder
# module ThingRequestBuilder
# module RelationRequestBuilder
# module AttributeRequestBuilder
# module RuleRequestBuilder


end # RequestBuilder
