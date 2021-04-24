# This file is a part of GraknClient.  License is MIT: https://github.com/Humans-of-Julia/GraknClient.jl/blob/main/LICENSE

#=
In root folder run $ bash setup.sh to genrate the proto files

then install the packages from GitHub
Pkg.rm("gRPCClient")
Pkg.add(url="https://github.com/JuliaComputing/gRPCClient.jl")
] dev gRPCClient

=#
module GraknClient

using Dates
using DataStructures
using gRPCClient
using Pretend: Pretend, @mockable
using Sockets
using UUIDs: UUID, uuid4

# TODO no need to import these; best practrice is to prefix module name
#  when you extend the function
import Base: show, close, ==

###### abstract types ##################
#                                      #
########################################

abstract type AbstractCoreDatabaseManager end

abstract type AbstracClient end
abstract type AbstractClusterClient <: AbstracClient end
abstract type AbstractCoreClient <: AbstracClient end

abstract type AbstractCoreSession end
abstract type AbstractCoreTransaction end
abstract type AbstractLogicManager end
abstract type AbstractQueryManager end

###### inlcudes ########################
#                                      #
########################################

#generated section
include("generated/grakn.jl")
include("generated/core_service_pb.jl")

#standard julia sources
include("standard/type_aliases.jl")
include("standard/utils.jl")

#common section
include("common/Label.jl")
include("common/exception/ErrorMessage.jl")
include("common/exception/GraknClientException.jl")
include("common/rpc/GraknStub.jl")
include("common/rpc/RequestBuilder.jl")

#concepts
include("concept/Concept.jl")
include("concept/type/RoleType.jl")
include("concept/type/RelationType.jl")
include("concept/thing/Relation.jl")

include("concept/type/Type.jl")
include("concept/type/RoleType.jl")
include("concept/type/ThingType.jl")
include("concept/type/AttributeType.jl")
include("concept/type/EntityType.jl")
include("concept/type/RelationType.jl")

include("concept/thing/Attribute.jl")
include("concept/thing/Entity.jl")
include("concept/thing/Relation.jl")
include("concept/thing/Thing.jl")

include("concept/answer/ConceptMap.jl")


#api section
include("api/GraknOptions.jl")

#stream section
include("stream/RequestTransmitter.jl")
include("stream/ResponseCollector.jl")
include("stream/BidirectionalStream.jl")

#core section
include("core/CoreDatabase.jl")
include("core/CoreDatabaseManager.jl")
include("core/CoreClient.jl")
include("core/CoreSession.jl")
include("core/CoreTransaction.jl")

# part of common section -- place because of general grpc resulthandling
include("common/exception/gRPC_Result_Handling.jl")


export GraknCoreBlockingClient, GraknClientException
export contains_database


# export  Session, Transaction

####### pretty printing sectoin ##################

Base.show(io::IO, blocking_stub::GraknCoreBlockingStub) = Base.print(io,blocking_stub)
function Base.print(io::IO, blocking_stub::GraknCoreBlockingStub)
    print(io, "GraknCoreBlockingStub($(blocking_stub.impl.channel))")
    return nothing
end

## Printing UUId stored in Vector in a more readable way
Base.show(io::IO, id::Array{UInt8,1}) = print(io, id)
Base.print(io::IO, id::Array{UInt8,1}) = print(io, string(bytes2hex(id)))

## Printing each request in a shorter form except they have speicalized
## printing options.
Base.show(io::IO, item::T) where {T<:ProtoType} = print(io, item)
function Base.print(io::IO, item::T) where {T<:ProtoType}
    erg  = collect(keys(meta(typeof(item)).symdict))
    str_item = ""
    for attr in erg
        if hasproperty(item, attr)
            str_item *= string(attr) * ": " * string(getproperty(item,attr))
            break
        end
    end
    out_string = string(nameof(typeof(item))) * " ($str_item)"
    print(io, out_string)

    return nothing
end

########## precompiling section

@assert precompile(meta, (Type{Proto.Type_Res}, ))
@assert precompile(meta, (Type{Proto.Type_Req}, ))
@assert precompile(meta, (Type{Proto.Transaction_Res}, ))
@assert precompile(meta, (Type{Proto.Transaction_ResPart}, ))

@assert precompile(which_oneof, (Proto.Transaction_ResPart, Symbol))
@assert precompile(which_oneof, (Proto.Transaction_Res, Symbol))
@assert precompile(single_request, (BidirectionalStream, Proto.Transaction_Req, Bool))
@assert precompile(_open_result_channel, (BidirectionalStream, Proto.Transaction_Req, Bool))
@assert precompile(collect_result, (Channel{Union{Proto.Transaction_Res,Proto.Transaction_ResPart}}, ))
@assert precompile(_is_stream_respart_done, (Proto.Transaction_Res, ))
@assert precompile(_is_stream_respart_done, (Proto.Transaction_ResPart, ))

end #module
