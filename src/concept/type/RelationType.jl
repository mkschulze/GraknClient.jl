struct RelationType <: AbstractRelationType
    label::Label
    is_root::Bool
end

RelationType(t::Proto._Type) = RelationType(Label(t.label), t.root)

function create(x::Remote{RelationType})
    result = execute(RelationTypeRequestBuilder.create_req(x.data.label))
    return Relation(result.relation_type_create_res.relation)
end

# TODO this is a stub for testing the above `create` function only. Should be removed.
function execute(x::Proto.Transaction_Req)
    # println("execute: $x")
    return Proto.Type_Res(
        relation_type_create_res = Proto.RelationType_Create_Res(
            relation = Proto.Thing(
                iid = [0x01],
                _type = Proto._Type(
                    label = "a",
                    root = true
                )
            )
        )
    )
end

# Remote functions

function create(x::Remote{RelationType})
    result = execute(x.transaction, RelationTypeRequestBuilder.create_req(x.concept.label))
    return Relation(result.relation_type_create_res.relation)
end

