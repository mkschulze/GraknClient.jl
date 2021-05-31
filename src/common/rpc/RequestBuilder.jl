# This file is a part of TypeDBClient.  License is MIT: https://github.com/Humans-of-Julia/TypeDBClient.jl/blob/main/LICENSE

# ---------------------------------------------------------------------------------
module DatabaseManagerRequestBuilder

using ..TypeDBClient: Proto

create_req(name::String) = Proto.CoreDatabaseManager_Create_Req(; name)

contains_req(name::String) = Proto.CoreDatabaseManager_Contains_Req(; name)

all_req() = Proto.CoreDatabaseManager_All_Req()

end

# ---------------------------------------------------------------------------------
module DatabaseRequestBuilder

using ..TypeDBClient: Proto

schema_req(name::String) = Proto.CoreDatabase_Schema_Req(; name)

delete_req(name::String) = Proto.CoreDatabase_Delete_Req(; name)

end

# ---------------------------------------------------------------------------------
module SessionRequestBuilder

using ..TypeDBClient: Proto, EnumType, Bytes

function open_req(database::String, _type::EnumType, options::Proto.Options)
    return Proto.Session_Open_Req(; database, _type, options)
end

close_req(session_id::Bytes) = Proto.Session_Close_Req(; session_id)

pulse_req(session_id::Bytes) = Proto.Session_Pulse_Req(; session_id)

end

# ---------------------------------------------------------------------------------
module TransactionRequestBuilder

using ..TypeDBClient: Proto, EnumType, Bytes
using UUIDs: UUID

function client_msg(reqs::AbstractVector{Proto.Transaction_Req})
    return Proto.Transaction_Client(; reqs)
end

function stream_req(req_id::Bytes)
    stream_req = Proto.Transaction_Stream_Req()
    return Proto.Transaction_Req(; req_id, stream_req)
end

function open_req(
    session_id::Bytes,
    _type::EnumType,
    options::Proto.Options,
    network_latency_millis::Int
)
    open_req = Proto.Transaction_Open_Req(;
        session_id, _type, options, network_latency_millis
    )
    return Proto.Transaction_Req(; open_req)
end

function commit_req()
    # metadata = tracing_data()
    commit_req = Proto.Transaction_Commit_Req()
    return Proto.Transaction_Req(; commit_req)
end

end

# ---------------------------------------------------------------------------------
module QueryManagerRequestBuilder

using ..TypeDBClient: Proto

for (f, t) in (
    (:define_req,                :Define_Req),
    (:undefine_req,              :Undefine_Req),
    (:match_req,                 :Match_Req),
    (:match_aggregate_req,       :MatchAggregate_Req),
    (:match_group_req,           :MatchGroup_Req),
    (:match_group_aggregate_req, :MatchGroupAggregate_Req),
    (:insert_req,                :Insert_Req),
    (:delete_req,                :Delete_Req),
    (:update_req,                :Update_Req),
)
    func = Symbol("$f")
    type = Symbol("QueryManager_$t")
    @eval begin
        function $func(query::String, options::Proto.Options = Proto.Options())
            $f = Proto.$type(; query)
            query_manager_req = Proto.QueryManager_Req(; $f, options)
            return Proto.Transaction_Req(; query_manager_req)
        end
    end
end

end

# ---------------------------------------------------------------------------------
module ConceptManagerRequestBuilder

using ..TypeDBClient: Proto, EnumType, bytes

function _treq(; kwargs...)
    return Proto.Transaction_Req(
        concept_manager_req = Proto.ConceptManager_Req(; kwargs...)
    )
end

function put_entity_type_req(label::String)
    return _treq(
        put_entity_type_req = Proto.ConceptManager_PutEntityType_Req(; label)
    )
end

function put_relation_type_req(label::String)
    return _treq(
        put_relation_type_req = Proto.ConceptManager_PutRelationType_Req(; label)
    )
end

function put_attribute_type_req(label::String, value_type::EnumType)
    return _treq(
        put_attribute_type_req =
            Proto.ConceptManager_PutAttributeType_Req(; label, value_type)
    )
end

function get_thing_type_req(label::String)
    return _treq(
        get_thing_type_req = Proto.ConceptManager_GetThingType_Req(; label)
    )
end

function get_thing_req(iid::String)
    return _treq(
        get_thing_req = Proto.ConceptManager_GetThing_Req(; iid = bytes(iid))
    )
end

end

# ---------------------------------------------------------------------------------
module LogicManagerRequestBuilder

using ..TypeDBClient: Proto

function _treq(; kwargs...)
    return Proto.Transaction_Req(
        logic_manager_req = Proto.LogicManager_Req(
            ; kwargs...
        )
    )
end

function put_rule_req(label::String, when::String, then::String)
    return _treq(
        put_rule_req = Proto.LogicManager_PutRule_Req(; label, when, then)
    )
end

function get_rule_req(label::String)
    return _treq(
        get_rule_req = Proto.LogicManager_GetRule_Req(; label)
    )
end

function get_rules_req()
    return _treq(
        get_rules_req = Proto.LogicManager_GetRules_Req()
    )
end

end

# ---------------------------------------------------------------------------------
module TypeRequestBuilder

using ..TypeDBClient: Proto, Label

# Ignore linter error here
function _treq(label, scope; kwargs...)
    scope !== nothing && return Proto.Transaction_Req(
        type_req = Proto.Type_Req(; label, scope, kwargs...)
    )
    return Proto.Transaction_Req(
        type_req = Proto.Type_Req(; label, kwargs...)
    )
end

function is_abstract_req(label::Label)
    return _treq(label.name, label.scope;
        type_is_abstract_req = Proto.Type_IsAbstract_Req()
    )
end

function set_label_req(label::Label, new_label::String)
    return _treq(label.name, label.scope;
        type_set_label_req = Proto.Type_SetLabel_Req(
            label = new_label
        )
    )
end

function get_supertypes_req(label::Label)
    return _treq(label.name, label.scope;
        type_get_supertypes_req = Proto.Type_GetSupertypes_Req()
    )
end

function get_subtypes_req(label::Label)
    return _treq(label.name, label.scope;
        type_get_subtypes_req = Proto.Type_GetSubtypes_Req()
    )
end

function get_supertype_req(label::Label)
    return _treq(label.name, label.scope;
        type_get_supertype_req = Proto.Type_GetSupertype_Req()
    )
end

function delete_req(label::Label)
    return _treq(label.name, label.scope;
        type_delete_req = Proto.Type_Delete_Req()
    )
end

end

# ---------------------------------------------------------------------------------
module RoleTypeRequestBuilder

using ..TypeDBClient: Proto, EnumType, Label
using ..TypeRequestBuilder: _treq

# TODO to be deprecated, see porting note at RoleType.jl
function proto_role_type(label::Label, encoding::EnumType)
    @assert label.scope !== nothing
    return Proto._Type(
        scope = label.scope,
        label = label.name,
        encoding = encoding,
    )
end

function get_relation_types_req(label::Label)
    return _treq(label.name, label.scope;
        role_type_get_relation_types_req = Proto.RoleType_GetRelationTypes_Req()
    )
end

function get_players_req(label::Label)
    return _treq(label.name, label.scope;
        role_type_get_players_req = Proto.RoleType_GetPlayers_Req()
    )
end

end

# ---------------------------------------------------------------------------------
module ThingTypeRequestBuilder

using ..TypeDBClient: Proto, EnumType, Label, Optional
using ..TypeRequestBuilder: _treq

# TODO to be deprecated, see porting note at RoleType.jl
function proto_thing_type(label::Label, encoding::EnumType)
    return Proto._Type(
        label = label.name,
        encoding = encoding
    )
end

function set_abstract_req(label::Label)
    return _treq(label.name, label.scope;
        thing_type_set_abstract_req = Proto.ThingType_SetAbstract_Req()
    )
end

function unset_abstract_req(label::Label)
    return _treq(label.name, label.scope;
        thing_type_unset_abstract_req = Proto.ThingType_UnsetAbstract_Req()
    )
end

function set_supertype_req(label::Label)
    return _treq(label.name, label.scope;
        type_set_supertype_req = Proto.Type_SetSupertype_Req()
    )
end

function get_plays_req(label::Label)
    return _treq(label.name, label.scope;
        thing_type_get_plays_req = Proto.ThingType_GetPlays_Req()
    )
end

function set_plays_req(
    label::Label,
    role_type::Proto.RoleType,
    overridden_role_type::Optional{Proto.RoleType} = nothing
)
    return _treq(label.name, label.scope;
        thing_type_set_plays_req = Proto.ThingType_SetPlays_Req(
            role = role_type,
            overridden_role = overridden_role_type
        )
    )
end

function unset_plays_req(
    label::Label, role_type::Proto.RoleType
)
    return _treq(label.name, label.scope;
        thing_type_unset_plays_req = Proto.ThingType_UnsetPlays_Req(
            role = role_type,
        )
    )
end

# Porting note: the order of `keys_only` and `value_type` are swapped
function get_owns_req(
    label::Label,
    keys_only::Bool,
    value_type::Optional{EnumType} = nothing
)
    return _treq(label.name, label.scope;
        thing_type_get_owns_req = Proto.ThingType_GetOwns_Req(; keys_only, value_type)
    )
end

# Porting note: the order of `is_key` is moved upfront
function set_owns_req(
    label::Label,
    is_key::Bool,
    attribute_type::Proto.AttributeType,
    overridden_type::Optional{Proto.AttributeType} = nothing
)
    return _treq(label.name, label.scope;
        thing_type_set_owns_req = Proto.ThingType_SetOwns_Req(;
            is_key, attribute_type, overridden_type
        )
    )
end

function unset_owns_req(label::Label, attribute_type::Proto.AttributeType)
    return _treq(label.name, label.scope;
        thing_type_unset_owns_req = Proto.ThingType_UnsetOwns_Req(; attribute_type)
    )
end

function get_instances_req(label::Label)
    return _treq(label.name, label.scope;
        thing_type_get_instances_req = Proto.ThingType_GetInstances_Req()
    )
end

end

# ---------------------------------------------------------------------------------
module EntityTypeRequestBuilder

using ..TypeDBClient: Proto, Label
using ..TypeRequestBuilder: _treq

function create_req(label::Label)
    return _treq(label.name, label.scope;
        entity_type_create_req = Proto.EntityType_Create_Req()
    )
end

end

# ---------------------------------------------------------------------------------
module RelationTypeRequestBuilder

using ..TypeDBClient: Proto, Label, Optional
using ..TypeRequestBuilder: _treq

function create_req(label::Label)
    return _treq(label.name, label.scope;
        relation_type_create_req = Proto.RelationType_Create_Req()
    )
end

function get_relates_req(label::Label, role_label::Optional{String})
    return _treq(label.name, label.scope;
        relation_type_get_relates_req = Proto.RelationType_GetRelates_Req(;
            label = role_label
        )
    )
end

function set_relates_req(
    label::Label, role_label::String, overridden_label::Optional{String}
)
    return _treq(label.name, label.scope;
        relation_type_set_relates_req = Proto.RelationType_SetRelates_Req(;
            label = role_label,
            overridden_label
        )
    )
end

function unset_relates_req(label::Label, role_label::Optional{String})
    return _treq(label.name, label.scope;
        relation_type_unset_relates_req = Proto.RelationType_UnsetRelates_Req(;
            label = role_label
        )
    )
end

end

# ---------------------------------------------------------------------------------
module ThingRequestBuilder

using ..TypeDBClient: Proto, Label, Bytes, bytes

proto_thing(iid::Bytes) = Proto.Thing(; iid)
proto_thing(iid::String) = proto_thing(bytes(iid))

function _thing_req(iid::String; kwargs...)
    return Proto.Transaction_Req(
        thing_req = Proto.Thing_Req(
            ; iid = bytes(iid), kwargs...
        )
    )
end

function is_inferred_req(iid::String)
    return _thing_req(iid;
        thing_is_inferred_req = Proto.Thing_IsInferred_Req()
    )
end

function get_has_req(iid::String, attribute_types::AbstractVector{Proto.Type})
    return _thing_req(iid;
        thing_get_has_req = Proto.Thing_GetHas_Req(; attribute_types)
    )
end

function get_has_req(iid::String, only_key::Bool)
    return _thing_req(iid;
        thing_get_has_req = Proto.Thing_GetHas_Req(; only_key)
    )
end

function set_has_req(iid::String, attribute::Proto.Thing)
    return _thing_req(iid;
        thing_set_has_req = Proto.Thing_SetHas_Req(; attribute)
    )
end

function unset_has_req(iid::String, attribute::Proto.Thing)
    return _thing_req(iid;
        thing_unset_has_req = Proto.Thing_UnsetHas_Req(; attribute)
    )
end

function get_playing_req(iid::String)
    return _thing_req(iid;
        thing_get_playing_req = Proto.Thing_GetPlaying_Req()
    )
end

function get_relations_req(iid::String, role_types::AbstractVector{Proto._Type})
    return _thing_req(iid;
        thing_get_relations_req = Proto.Thing_GetRelations_Req(; role_types)
    )
end

function delete_req(iid::String)
    return _thing_req(iid;
        thing_delete_req = Proto.Thing_Delete_Req()
    )
end

end

# ---------------------------------------------------------------------------------
module RelationRequestBuilder

using ..TypeDBClient: Proto
using ..ThingRequestBuilder: _thing_req

function add_player_req(iid::String, role_type::Proto._Type, player::Proto.Thing)
    return _thing_req(iid;
        relation_add_player_req = Proto.Relation_AddPlayer_Req(;
            role_type,
            player
        )
    )
end

function remove_player_req(iid::String, role_type::Proto._Type, player::Proto.Thing)
    return _thing_req(iid;
        relation_remove_player_req = Proto.Relation_RemovePlayer_Req(;
            role_type,
            player
        )
    )
end

function get_players_req(iid::String, role_types::AbstractVector{Proto._Type})
    return _thing_req(iid;
        relation_get_players_req = Proto.Relation_GetPlayers_Req(; role_types)
    )
end

function get_players_by_role_type_req(iid::String)
    return _thing_req(iid;
        relation_get_players_by_role_type_req = Proto.Relation_GetPlayersByRoleType_Req()
    )
end

function get_relating_req(iid::String)
    return _thing_req(iid;
        relation_get_players_req = Proto.Relation_GetRelating_Req()
    )
end

end

# ---------------------------------------------------------------------------------
module AttributeRequestBuilder

using ..TypeDBClient: Proto, Optional
using ..ThingRequestBuilder: _thing_req
using TimeZones: ZonedDateTime

function get_owners_req(iid::String, owner_type::Optional{Proto._Type})
    return _thing_req(iid;
        relation_get_owners_req = Proto.Relation_GetOwners_Req(),
        thing_type = owner_type
    )
end

proto_boolean_attribute_value(value::Bool) = Proto.Attribute_Value(; boolean = value)
proto_long_attribute_value(value::Int64) = Proto.Attribute_Value(; long = value)
proto_double_attribute_value(value::Float64) = Proto.Attribute_Value(; double = value)
proto_string_attribute_value(value::String) = Proto.Attribute_Value(; string = value)

function proto_date_time_attribute_value(value::ZonedDateTime)
    epoch_millis = value.utc_datetime.instant
    Proto.Attribute_Value(; date_time = epoch_millis)
end

end

# ---------------------------------------------------------------------------------
module RuleRequestBuilder

using ..TypeDBClient: Proto

function set_label_req(current_label::String, new_label::String)
    return Proto.Transaction_Req(
        rule_req = Proto.Rule_Req(
            label = current_label,
            rule_set_label_req = Proto.Rule_SetLabel_Req(
                label = new_label
            )
        )
    )
end

function delete_req(label::String)
    return Proto.Transaction_Req(
        rule_req = Proto.Rule_Req(
            rule_delete_req = Proto.Rule_Delete_Req()
        )
    )
end

end
