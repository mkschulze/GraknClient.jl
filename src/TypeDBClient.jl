# This file is a part of TypeDBClient.  License is MIT: https://github.com/Humans-of-Julia/TypeDBClient.jl/blob/main/LICENSE

#=
In root folder run $ bash setup.sh to genrate the proto files

then install the packages from GitHub
Pkg.rm("gRPCClient")
Pkg.add(url="https://github.com/JuliaComputing/gRPCClient.jl")


Pkg.rm("ExecutableSpecifications")
Pkg.add(url="https://github.com/erikedin/Behavior.jl")
] dev Behavior
] dev gRPCClient
=#
module TypeDBClient

using Dates
using DataStructures
using gRPCClient
using Pretend: Pretend, @mockable
using ProtoBuf: which_oneof
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
include("generated/typedb.jl")
# include("generated/core_service_pb.jl")

#standard julia sources
include("standard/type_aliases.jl")
include("standard/utils.jl")

#common section
include("common/Label.jl")
include("common/exception/ErrorMessage.jl")
include("common/exception/TypeDBClientException.jl")
include("common/rpc/TypeDBStub.jl")
include("common/rpc/RequestBuilder.jl")

#concepts
include("concept/Concept.jl")

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

include("concept/ConceptManager.jl")

include("concept/answer/ConceptMap.jl")
include("concept/answer/ConceptMapGroup.jl")
include("concept/answer/NumericGroup.jl")

#query section
include("query/QueryManager.jl")

#logic
include("logic/Rule.jl")
include("logic/Explanation.jl")
include("logic/LogicManager.jl")

#api section
include("api/TypeDBOptions.jl")

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

# precompiling section
include("precompile.jl")
include("exports.jl")

####### pretty printing section ##################

function Base.show(io::IO, blocking_stub::Proto.TypeDBBlockingStub)
    print(io, "TypeDBBlockingStub($(blocking_stub.impl.channel))")
    return nothing
end

## Printing UUId stored in Vector in a more readable way
Base.show(io::IO, id::Bytes) = print(io, string(bytes2hex(id)))

## Printing each request in a shorter form except they have specialized
## printing options.
function Base.show(io::IO, item::Proto.ProtoType)
    erg  = collect(keys(Proto.meta(typeof(item)).symdict))
    print(io, string(nameof(typeof(item))))
    for attr in erg
        if hasproperty(item, attr)
            print(io, " ", string(attr, ": " , string(getproperty(item,attr))))
            break
        end
    end
    return nothing
end

end #module
