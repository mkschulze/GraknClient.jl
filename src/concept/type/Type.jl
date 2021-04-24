# This file is a part of GraknClient.  License is MIT: https://github.com/Humans-of-Julia/GraknClient.jl/blob/main/LICENSE

function create(t::Proto._Type)
    if t.encoding == Proto.Type_Encoding.ROLE_TYPE
        return RoleType(t)
    else
        # TODO
        # return ThingType(t)
    end
end

"""
    instantiate(p)

Create a suitable object according to the type specified in the ProtoBuf object `p`.
Return value will be a subtype of `AbstractType`.
"""
function instantiate(t::Proto._Type)
    label = hasproperty(t, :scope) ? Label(t.scope, t.label) : Label(t.label)
    if t.encoding == Proto.Type_Encoding.ROLE_TYPE
        return RoleType(label, t.root)
    elseif t.encoding == Proto.Type_Encoding.RELATION_TYPE
        return RelationType(label, t.root)
    elseif t.encoding == Proto.Type_Encoding.ATTRIBUTE_TYPE
        return AttributeType(label, t.root, t.value_type)
    elseif t.encoding == Proto.Type_Encoding.ENTITY_TYPE
        return EntityType(label, t.root)
    elseif t.encoding == Proto.Type_Encoding.THING_TYPE
        return ThingType(label, t.root)
    else
        throw(GraknClientException(CONCEPT_BAD_ENCODING, t.encoding))
    end
end

"""
    encoding(t)

Return the ProtoBuf encoding value for the given concept type `t`.
"""
function encoding end

encoding(t::AbstractEntityType) = Proto.Type_Encoding.ENTITY_TYPE
encoding(t::AbstractRelationType) = Proto.Type_Encoding.RELATION_TYPE
encoding(t::AbstractAttributeType) = Proto.Type_Encoding.ATTRIBUTE_TYPE
encoding(t::AbstractRoleType) = Proto.Type_Encoding.ROLE_TYPE
encoding(t::AbstractThingType) = Proto.Type_Encoding.THING_TYPE

# TODO The UNRECOGNIZED enum is missing; need to regenerate from proto?
# encoding(t::AbstractType) = Proto.Type_Encoding.UNRECOGNIZED

# I don't think this is unnecessary since the user can broadcast themselves
# proto(types::AbstractVector{T}) where {T <: AbstractType} = proto.(types)

