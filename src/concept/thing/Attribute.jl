# This file is a part of GraknClient.  License is MIT: https://github.com/Humans-of-Julia/GraknClient.jl/blob/main/LICENSE

struct Attribute{S, T} <: AbstractThing
    iid::String
    type::AttributeType{S}
    value::T
end

function Attribute(t::Proto.Thing)
    iid = bytes2hex(t.iid)
    isempty(iid) && throw(GraknClientException(CONCEPT_MISSING_IID))

    attribute_type = instantiate(t._type)
    value_type = first(typeof(attribute_type).parameters)

    if value_type == Proto.AttributeType_ValueType.BOOLEAN
        return Attribute(iid, attribute_type, t.value.boolean)
    elseif value_type == Proto.AttributeType_ValueType.LONG
        return Attribute(iid, attribute_type, t.value.long)
    elseif value_type == Proto.AttributeType_ValueType.DOUBLE
        return Attribute(iid, attribute_type, t.value.double)
    elseif value_type == Proto.AttributeType_ValueType.STRING
        return Attribute(iid, attribute_type, t.value.string)
    elseif value_type == Proto.AttributeType_ValueType.DATETIME
        return Attribute(iid, attribute_type, t.value.date_time)
    else
        throw(GraknClientException(CONCEPT_BAD_VALUE_TYPE))
    end
end