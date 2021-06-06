# This file is a part of TypeDBClient.  License is MIT: https://github.com/Humans-of-Julia/TypeDBClient.jl/blob/main/LICENSE

# This example uses the social_network dataset. You can create the schema and upload data
# by following instructionns from https://docs.grakn.ai/docs/general/quickstart

using Revise

using TypeDBClient
import TypeDBClient.typedb.protocol as P

client = Client("127.0.0.1")
session = Session(client, "social_network", P.Session_Type.DATA)


# ------------------------------------------------------------------
# general query

function query(q::AbstractString)
    transaction = Transaction(
        session, session.sessionID, P.Transaction_Type.READ, TypeDBOptions()
    )
    result = TypeDBClient.match(transaction, q)
    close(transaction)
    return result
end

# Getting attributes
raw_result = query(raw"""
    match $p isa person, has full-name $n, has gender $g; get $n, $g;
    """)
result = map(r -> (fullname = r["n"].value, gender = r["g"].value),
    raw_result)

# Getting entities
raw_result = query(raw"""match $p isa person; get $p;""")
result = map(r -> (iid = r["p"].iid,), raw_result)

# Getting relations
raw_result = query(raw"""match $emp (employer: $x, employee: $y) isa employment; get $emp;""")

#=
typedb console returns the related iid's also!

Julia:
 ConceptMap:
    1. emp => TypeDBClient.Relation("aa8280058000000000000006",
        TypeDBClient.RelationType(:employment, false))

Console:
{ $emp iid 0xaa828005800000000000000a (
    employment:employer: iid 0x966e800a8000000000000003,
    employment:job: iid 0x966e800e8000000000000007,
    employment:employee: iid 0x966e8009800000000000000e) isa employment;
}
=#

# ------------------------------------------------------------------
# ConceptManager methods

function cm_call(f::Function, session::Session)
    transaction = Transaction(session, session.sessionID, P.Transaction_Type.READ, TypeDBOptions())
    concept_manager = ConceptManager(transaction)
    res = f(concept_manager)
    close(transaction)
    return res
end

cm_call(session) do concept_manager
    @show get(concept_manager, ThingType, "title")
    @show get(concept_manager, AttributeType, "title")  # same as ThingType
    @show get(concept_manager, EntityType, "title") # nothing
    @show get(concept_manager, RelationType, "title") # nothing
    nothing
end

cm_call(session) do concept_manager
    @show get(concept_manager, Entity, "966e800c8000000000000000")
    nothing
end

# ------------------------------------------------------------------
# ThingType methods

# Fetch a thing_type for testing
function thing_call(f::Function, session::Session, name::AbstractString)
    cm_call(session) do concept_manager
        thing_type_res = TypeDBClient.execute(
            concept_manager, TypeDBClient.ConceptManagerRequestBuilder.get_thing_type_req(name)
        )
        thing_type = TypeDBClient.instantiate(thing_type_res.get_thing_type_res.thing_type)
        remote_thing = TypeDBClient.as_remote(thing_type, concept_manager.transaction)
        f(remote_thing)
    end
end

res = thing_call(thing -> get_supertype(thing), session, "title")

res = thing_call(thing -> get_supertypes(thing), session, "approved-date")

res = thing_call(thing -> get_subtypes(thing), session, "event-date")

res = thing_call(thing -> get_instances(thing), session, "school") # entities
res = thing_call(thing -> get_instances(thing), session, "title") # attributes
res = thing_call(thing -> get_instances(thing), session, "ownership") # relations

res = thing_call(thing -> get_owns(thing), session, "person")
res = thing_call(thing -> get_owns(thing, VALUE_TYPE.BOOLEAN), session, "person")
res = thing_call(thing -> get_owns(thing, nothing, true), session, "person")

res = thing_call(thing -> get_plays(thing), session, "location")

# ------------------------------------------------------------------
# AttributeType methods

res = thing_call(thing -> get_regex(thing), session, "emotion")
res = thing_call(thing -> get_regex(thing), session, "title") # nothing

# TODO [INT03] Invalid Internal State: Illegal internal operation! This method should not have been called.
res = thing_call(thing -> set_regex(thing, raw".*"), session, "title")

# TODO [TYW03] Invalid Type Write: The type 'media' has instances, and cannot be set abstract.
# Should probably create my own attribute and set it to abstract
res = thing_call(thing -> set_abstract(thing), session, "media")

# TODO [INT03] Invalid Internal State: Illegal internal operation! This method should not have been called.
# Should probably create my own attribute and set it to abstract and then unset it
res = thing_call(thing -> unset_abstract(thing), session, "media")

# Isn't it a little dumb to get back what I passed?
res = thing_call(thing -> get(thing, "Biochemistry"), session, "title")
res = thing_call(thing -> get(thing, "Foo"), session, "title") # nothing

# TODO - what does it mean when calling Put method on an AttributeType
# https://discord.com/channels/762167454973296644/773324706924593192/851000661583986698
res = thing_call(thing -> TypeDBClient.put(thing, "Foo"), session, "title")

res = thing_call(thing -> get_subtypes(thing), session, "title")

# TODO - need an example to test the special get_subtypes filtering logic
# https://discord.com/channels/665254494820368395/837321963814912020/851164383714476074
# res = thing_call(thing -> get_subtypes(thing), session, "attribute")


close(session)
close(client)
