struct RelationType <: AbstractRelationType
    label::Label
    is_root::Bool
end

# Remote functions

function create(x::RemoteConcept{RelationType})
    result = execute(x.transaction, RelationTypeRequestBuilder.create_req(x.concept.label))
    return Relation(result.relation_type_create_res.relation)
end
