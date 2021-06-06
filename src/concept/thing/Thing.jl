# This file is a part of TypeDBClient.  License is MIT: https://github.com/Humans-of-Julia/TypeDBClient.jl/blob/main/LICENSE

# Porting note:
# There is no need for a `Thing` type because it's an abstract thing that could just be
# an entity, relation, of attribute. See `instantiate` function below.

function instantiate(t::Proto.Thing)
    if t._type.encoding == Proto.Type_Encoding.ENTITY_TYPE
        return Entity(t)
    elseif t._type.encoding == Proto.Type_Encoding.RELATION_TYPE
        return Relation(t)
    elseif t._type.encoding == Proto.Type_Encoding.ATTRIBUTE_TYPE
        return Attribute(t)
    else
        throw(TypeDBClientException(CONCEPT_BAD_ENCODING))
    end
end


