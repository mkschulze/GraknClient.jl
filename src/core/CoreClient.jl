# This file is a part of TypeDBClient.  License is MIT: https://github.com/Humans-of-Julia/TypeDBClient.jl/blob/main/LICENSE

mutable struct CoreClient <: AbstractCoreClient
    channel::gRPCClient.gRPCChannel
    address::String
    port::Int
    core_stub::Core_TypeDBStub
    databaseMgr::CoreDatabaseManager
    sessions::Dict{Bytes, Optional{AbstractCoreSession}}
end

function Base.show(io::IO, core_client::CoreClient)
    print(io, "CoreClient(address: $(core_client.address):$(core_client.port))")
end

function CoreClient(address::String, port::Int = 1729)
    channel = gRPCChannel(address * ":" * string(port))
    stub = Core_TypeDBStub(channel)
    databaseMgr = CoreDatabaseManager()
    sessions = Dict{String, Union{<:AbstractCoreSession, Nothing}}()
    return CoreClient(channel,address, port, stub, databaseMgr,sessions)
end

is_cluster(client::AbstractCoreClient) = false

function remove_session(client::AbstractCoreClient, session::AbstractCoreSession)
    delete!(client.sessions, session.sessionID)
end
