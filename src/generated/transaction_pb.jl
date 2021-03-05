# This file is a part of GraknClient.  License is MIT: https://github.com/Humans-of-Julia/GraknClient.jl/blob/main/LICENSE

# syntax: proto3
using ProtoBuf
import ProtoBuf.meta

const Transaction_Type = (;[
    Symbol("READ") => Int32(0),
    Symbol("WRITE") => Int32(1),
]...)

mutable struct Transaction_Open_Req <: ProtoType
    __protobuf_jl_internal_meta::ProtoMeta
    __protobuf_jl_internal_values::Dict{Symbol,Any}
    __protobuf_jl_internal_defaultset::Set{Symbol}

    function Transaction_Open_Req(; kwargs...)
        obj = new(meta(Transaction_Open_Req), Dict{Symbol,Any}(), Set{Symbol}())
        values = obj.__protobuf_jl_internal_values
        symdict = obj.__protobuf_jl_internal_meta.symdict
        for nv in kwargs
            fldname, fldval = nv
            fldtype = symdict[fldname].jtyp
            (fldname in keys(symdict)) || error(string(typeof(obj), " has no field with name ", fldname))
            values[fldname] = isa(fldval, fldtype) ? fldval : convert(fldtype, fldval)
        end
        obj
    end
end # mutable struct Transaction_Open_Req
const __meta_Transaction_Open_Req = Ref{ProtoMeta}()
function meta(::Type{Transaction_Open_Req})
    ProtoBuf.metalock() do
        if !isassigned(__meta_Transaction_Open_Req)
            __meta_Transaction_Open_Req[] = target = ProtoMeta(Transaction_Open_Req)
            allflds = Pair{Symbol,Union{Type,String}}[:session_id => Array{UInt8,1}, :_type => Int32, :options => Options]
            meta(target, Transaction_Open_Req, allflds, ProtoBuf.DEF_REQ, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
        end
        __meta_Transaction_Open_Req[]
    end
end
function Base.getproperty(obj::Transaction_Open_Req, name::Symbol)
    if name === :session_id
        return (obj.__protobuf_jl_internal_values[name])::Array{UInt8,1}
    elseif name === :_type
        return (obj.__protobuf_jl_internal_values[name])::Int32
    elseif name === :options
        return (obj.__protobuf_jl_internal_values[name])::Options
    else
        getfield(obj, name)
    end
end

mutable struct Transaction_Open_Res <: ProtoType
    __protobuf_jl_internal_meta::ProtoMeta
    __protobuf_jl_internal_values::Dict{Symbol,Any}
    __protobuf_jl_internal_defaultset::Set{Symbol}

    function Transaction_Open_Res(; kwargs...)
        obj = new(meta(Transaction_Open_Res), Dict{Symbol,Any}(), Set{Symbol}())
        values = obj.__protobuf_jl_internal_values
        symdict = obj.__protobuf_jl_internal_meta.symdict
        for nv in kwargs
            fldname, fldval = nv
            fldtype = symdict[fldname].jtyp
            (fldname in keys(symdict)) || error(string(typeof(obj), " has no field with name ", fldname))
            values[fldname] = isa(fldval, fldtype) ? fldval : convert(fldtype, fldval)
        end
        obj
    end
end # mutable struct Transaction_Open_Res
const __meta_Transaction_Open_Res = Ref{ProtoMeta}()
function meta(::Type{Transaction_Open_Res})
    ProtoBuf.metalock() do
        if !isassigned(__meta_Transaction_Open_Res)
            __meta_Transaction_Open_Res[] = target = ProtoMeta(Transaction_Open_Res)
            allflds = Pair{Symbol,Union{Type,String}}[:processing_time_millis => Int32]
            meta(target, Transaction_Open_Res, allflds, ProtoBuf.DEF_REQ, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
        end
        __meta_Transaction_Open_Res[]
    end
end
function Base.getproperty(obj::Transaction_Open_Res, name::Symbol)
    if name === :processing_time_millis
        return (obj.__protobuf_jl_internal_values[name])::Int32
    else
        getfield(obj, name)
    end
end

mutable struct Transaction_Open <: ProtoType
    __protobuf_jl_internal_meta::ProtoMeta
    __protobuf_jl_internal_values::Dict{Symbol,Any}
    __protobuf_jl_internal_defaultset::Set{Symbol}

    function Transaction_Open(; kwargs...)
        obj = new(meta(Transaction_Open), Dict{Symbol,Any}(), Set{Symbol}())
        values = obj.__protobuf_jl_internal_values
        symdict = obj.__protobuf_jl_internal_meta.symdict
        for nv in kwargs
            fldname, fldval = nv
            fldtype = symdict[fldname].jtyp
            (fldname in keys(symdict)) || error(string(typeof(obj), " has no field with name ", fldname))
            values[fldname] = isa(fldval, fldtype) ? fldval : convert(fldtype, fldval)
        end
        obj
    end
end # mutable struct Transaction_Open
const __meta_Transaction_Open = Ref{ProtoMeta}()
function meta(::Type{Transaction_Open})
    ProtoBuf.metalock() do
        if !isassigned(__meta_Transaction_Open)
            __meta_Transaction_Open[] = target = ProtoMeta(Transaction_Open)
            allflds = Pair{Symbol,Union{Type,String}}[]
            meta(target, Transaction_Open, allflds, ProtoBuf.DEF_REQ, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
        end
        __meta_Transaction_Open[]
    end
end

mutable struct Transaction_Commit_Req <: ProtoType
    __protobuf_jl_internal_meta::ProtoMeta
    __protobuf_jl_internal_values::Dict{Symbol,Any}
    __protobuf_jl_internal_defaultset::Set{Symbol}

    function Transaction_Commit_Req(; kwargs...)
        obj = new(meta(Transaction_Commit_Req), Dict{Symbol,Any}(), Set{Symbol}())
        values = obj.__protobuf_jl_internal_values
        symdict = obj.__protobuf_jl_internal_meta.symdict
        for nv in kwargs
            fldname, fldval = nv
            fldtype = symdict[fldname].jtyp
            (fldname in keys(symdict)) || error(string(typeof(obj), " has no field with name ", fldname))
            values[fldname] = isa(fldval, fldtype) ? fldval : convert(fldtype, fldval)
        end
        obj
    end
end # mutable struct Transaction_Commit_Req
const __meta_Transaction_Commit_Req = Ref{ProtoMeta}()
function meta(::Type{Transaction_Commit_Req})
    ProtoBuf.metalock() do
        if !isassigned(__meta_Transaction_Commit_Req)
            __meta_Transaction_Commit_Req[] = target = ProtoMeta(Transaction_Commit_Req)
            allflds = Pair{Symbol,Union{Type,String}}[]
            meta(target, Transaction_Commit_Req, allflds, ProtoBuf.DEF_REQ, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
        end
        __meta_Transaction_Commit_Req[]
    end
end

mutable struct Transaction_Commit_Res <: ProtoType
    __protobuf_jl_internal_meta::ProtoMeta
    __protobuf_jl_internal_values::Dict{Symbol,Any}
    __protobuf_jl_internal_defaultset::Set{Symbol}

    function Transaction_Commit_Res(; kwargs...)
        obj = new(meta(Transaction_Commit_Res), Dict{Symbol,Any}(), Set{Symbol}())
        values = obj.__protobuf_jl_internal_values
        symdict = obj.__protobuf_jl_internal_meta.symdict
        for nv in kwargs
            fldname, fldval = nv
            fldtype = symdict[fldname].jtyp
            (fldname in keys(symdict)) || error(string(typeof(obj), " has no field with name ", fldname))
            values[fldname] = isa(fldval, fldtype) ? fldval : convert(fldtype, fldval)
        end
        obj
    end
end # mutable struct Transaction_Commit_Res
const __meta_Transaction_Commit_Res = Ref{ProtoMeta}()
function meta(::Type{Transaction_Commit_Res})
    ProtoBuf.metalock() do
        if !isassigned(__meta_Transaction_Commit_Res)
            __meta_Transaction_Commit_Res[] = target = ProtoMeta(Transaction_Commit_Res)
            allflds = Pair{Symbol,Union{Type,String}}[]
            meta(target, Transaction_Commit_Res, allflds, ProtoBuf.DEF_REQ, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
        end
        __meta_Transaction_Commit_Res[]
    end
end

mutable struct Transaction_Commit <: ProtoType
    __protobuf_jl_internal_meta::ProtoMeta
    __protobuf_jl_internal_values::Dict{Symbol,Any}
    __protobuf_jl_internal_defaultset::Set{Symbol}

    function Transaction_Commit(; kwargs...)
        obj = new(meta(Transaction_Commit), Dict{Symbol,Any}(), Set{Symbol}())
        values = obj.__protobuf_jl_internal_values
        symdict = obj.__protobuf_jl_internal_meta.symdict
        for nv in kwargs
            fldname, fldval = nv
            fldtype = symdict[fldname].jtyp
            (fldname in keys(symdict)) || error(string(typeof(obj), " has no field with name ", fldname))
            values[fldname] = isa(fldval, fldtype) ? fldval : convert(fldtype, fldval)
        end
        obj
    end
end # mutable struct Transaction_Commit
const __meta_Transaction_Commit = Ref{ProtoMeta}()
function meta(::Type{Transaction_Commit})
    ProtoBuf.metalock() do
        if !isassigned(__meta_Transaction_Commit)
            __meta_Transaction_Commit[] = target = ProtoMeta(Transaction_Commit)
            allflds = Pair{Symbol,Union{Type,String}}[]
            meta(target, Transaction_Commit, allflds, ProtoBuf.DEF_REQ, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
        end
        __meta_Transaction_Commit[]
    end
end

mutable struct Transaction_Rollback_Req <: ProtoType
    __protobuf_jl_internal_meta::ProtoMeta
    __protobuf_jl_internal_values::Dict{Symbol,Any}
    __protobuf_jl_internal_defaultset::Set{Symbol}

    function Transaction_Rollback_Req(; kwargs...)
        obj = new(meta(Transaction_Rollback_Req), Dict{Symbol,Any}(), Set{Symbol}())
        values = obj.__protobuf_jl_internal_values
        symdict = obj.__protobuf_jl_internal_meta.symdict
        for nv in kwargs
            fldname, fldval = nv
            fldtype = symdict[fldname].jtyp
            (fldname in keys(symdict)) || error(string(typeof(obj), " has no field with name ", fldname))
            values[fldname] = isa(fldval, fldtype) ? fldval : convert(fldtype, fldval)
        end
        obj
    end
end # mutable struct Transaction_Rollback_Req
const __meta_Transaction_Rollback_Req = Ref{ProtoMeta}()
function meta(::Type{Transaction_Rollback_Req})
    ProtoBuf.metalock() do
        if !isassigned(__meta_Transaction_Rollback_Req)
            __meta_Transaction_Rollback_Req[] = target = ProtoMeta(Transaction_Rollback_Req)
            allflds = Pair{Symbol,Union{Type,String}}[]
            meta(target, Transaction_Rollback_Req, allflds, ProtoBuf.DEF_REQ, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
        end
        __meta_Transaction_Rollback_Req[]
    end
end

mutable struct Transaction_Req_MetadataEntry <: ProtoType
    __protobuf_jl_internal_meta::ProtoMeta
    __protobuf_jl_internal_values::Dict{Symbol,Any}
    __protobuf_jl_internal_defaultset::Set{Symbol}

    function Transaction_Req_MetadataEntry(; kwargs...)
        obj = new(meta(Transaction_Req_MetadataEntry), Dict{Symbol,Any}(), Set{Symbol}())
        values = obj.__protobuf_jl_internal_values
        symdict = obj.__protobuf_jl_internal_meta.symdict
        for nv in kwargs
            fldname, fldval = nv
            fldtype = symdict[fldname].jtyp
            (fldname in keys(symdict)) || error(string(typeof(obj), " has no field with name ", fldname))
            values[fldname] = isa(fldval, fldtype) ? fldval : convert(fldtype, fldval)
        end
        obj
    end
end # mutable struct Transaction_Req_MetadataEntry (mapentry)
const __meta_Transaction_Req_MetadataEntry = Ref{ProtoMeta}()
function meta(::Type{Transaction_Req_MetadataEntry})
    ProtoBuf.metalock() do
        if !isassigned(__meta_Transaction_Req_MetadataEntry)
            __meta_Transaction_Req_MetadataEntry[] = target = ProtoMeta(Transaction_Req_MetadataEntry)
            allflds = Pair{Symbol,Union{Type,String}}[:key => AbstractString, :value => AbstractString]
            meta(target, Transaction_Req_MetadataEntry, allflds, ProtoBuf.DEF_REQ, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
        end
        __meta_Transaction_Req_MetadataEntry[]
    end
end
function Base.getproperty(obj::Transaction_Req_MetadataEntry, name::Symbol)
    if name === :key
        return (obj.__protobuf_jl_internal_values[name])::AbstractString
    elseif name === :value
        return (obj.__protobuf_jl_internal_values[name])::AbstractString
    else
        getfield(obj, name)
    end
end

mutable struct Transaction_Req <: ProtoType
    __protobuf_jl_internal_meta::ProtoMeta
    __protobuf_jl_internal_values::Dict{Symbol,Any}
    __protobuf_jl_internal_defaultset::Set{Symbol}

    function Transaction_Req(; kwargs...)
        obj = new(meta(Transaction_Req), Dict{Symbol,Any}(), Set{Symbol}())
        values = obj.__protobuf_jl_internal_values
        symdict = obj.__protobuf_jl_internal_meta.symdict
        for nv in kwargs
            fldname, fldval = nv
            fldtype = symdict[fldname].jtyp
            (fldname in keys(symdict)) || error(string(typeof(obj), " has no field with name ", fldname))
            values[fldname] = isa(fldval, fldtype) ? fldval : convert(fldtype, fldval)
        end
        obj
    end
end # mutable struct Transaction_Req
const __meta_Transaction_Req = Ref{ProtoMeta}()
function meta(::Type{Transaction_Req})
    ProtoBuf.metalock() do
        if !isassigned(__meta_Transaction_Req)
            __meta_Transaction_Req[] = target = ProtoMeta(Transaction_Req)
            allflds = Pair{Symbol,Union{Type,String}}[:id => AbstractString, :metadata => Base.Dict{AbstractString,AbstractString}, :latency_millis => Int32, :_continue => Bool, :open_req => Transaction_Open_Req, :commit_req => Transaction_Commit_Req, :rollback_req => Transaction_Rollback_Req, :query_req => Query_Req, :concept_manager_req => ConceptManager_Req, :thing_req => Thing_Req, :type_req => Type_Req, :logic_manager_req => LogicManager_Req, :rule_req => Rule_Req]
            oneofs = Int[0,0,0,1,1,1,1,1,1,1,1,1,1]
            oneof_names = Symbol[Symbol("req")]
            meta(target, Transaction_Req, allflds, ProtoBuf.DEF_REQ, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, oneofs, oneof_names)
        end
        __meta_Transaction_Req[]
    end
end
function Base.getproperty(obj::Transaction_Req, name::Symbol)
    if name === :id
        return (obj.__protobuf_jl_internal_values[name])::AbstractString
    elseif name === :metadata
        return (obj.__protobuf_jl_internal_values[name])::Base.Dict{AbstractString,AbstractString}
    elseif name === :latency_millis
        return (obj.__protobuf_jl_internal_values[name])::Int32
    elseif name === :_continue
        return (obj.__protobuf_jl_internal_values[name])::Bool
    elseif name === :open_req
        return (obj.__protobuf_jl_internal_values[name])::Transaction_Open_Req
    elseif name === :commit_req
        return (obj.__protobuf_jl_internal_values[name])::Transaction_Commit_Req
    elseif name === :rollback_req
        return (obj.__protobuf_jl_internal_values[name])::Transaction_Rollback_Req
    elseif name === :query_req
        return (obj.__protobuf_jl_internal_values[name])::Query_Req
    elseif name === :concept_manager_req
        return (obj.__protobuf_jl_internal_values[name])::ConceptManager_Req
    elseif name === :thing_req
        return (obj.__protobuf_jl_internal_values[name])::Thing_Req
    elseif name === :type_req
        return (obj.__protobuf_jl_internal_values[name])::Type_Req
    elseif name === :logic_manager_req
        return (obj.__protobuf_jl_internal_values[name])::LogicManager_Req
    elseif name === :rule_req
        return (obj.__protobuf_jl_internal_values[name])::Rule_Req
    else
        getfield(obj, name)
    end
end

mutable struct Transaction_Rollback_Res <: ProtoType
    __protobuf_jl_internal_meta::ProtoMeta
    __protobuf_jl_internal_values::Dict{Symbol,Any}
    __protobuf_jl_internal_defaultset::Set{Symbol}

    function Transaction_Rollback_Res(; kwargs...)
        obj = new(meta(Transaction_Rollback_Res), Dict{Symbol,Any}(), Set{Symbol}())
        values = obj.__protobuf_jl_internal_values
        symdict = obj.__protobuf_jl_internal_meta.symdict
        for nv in kwargs
            fldname, fldval = nv
            fldtype = symdict[fldname].jtyp
            (fldname in keys(symdict)) || error(string(typeof(obj), " has no field with name ", fldname))
            values[fldname] = isa(fldval, fldtype) ? fldval : convert(fldtype, fldval)
        end
        obj
    end
end # mutable struct Transaction_Rollback_Res
const __meta_Transaction_Rollback_Res = Ref{ProtoMeta}()
function meta(::Type{Transaction_Rollback_Res})
    ProtoBuf.metalock() do
        if !isassigned(__meta_Transaction_Rollback_Res)
            __meta_Transaction_Rollback_Res[] = target = ProtoMeta(Transaction_Rollback_Res)
            allflds = Pair{Symbol,Union{Type,String}}[]
            meta(target, Transaction_Rollback_Res, allflds, ProtoBuf.DEF_REQ, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
        end
        __meta_Transaction_Rollback_Res[]
    end
end

mutable struct Transaction_Res <: ProtoType
    __protobuf_jl_internal_meta::ProtoMeta
    __protobuf_jl_internal_values::Dict{Symbol,Any}
    __protobuf_jl_internal_defaultset::Set{Symbol}

    function Transaction_Res(; kwargs...)
        obj = new(meta(Transaction_Res), Dict{Symbol,Any}(), Set{Symbol}())
        values = obj.__protobuf_jl_internal_values
        symdict = obj.__protobuf_jl_internal_meta.symdict
        for nv in kwargs
            fldname, fldval = nv
            fldtype = symdict[fldname].jtyp
            (fldname in keys(symdict)) || error(string(typeof(obj), " has no field with name ", fldname))
            values[fldname] = isa(fldval, fldtype) ? fldval : convert(fldtype, fldval)
        end
        obj
    end
end # mutable struct Transaction_Res
const __meta_Transaction_Res = Ref{ProtoMeta}()
function meta(::Type{Transaction_Res})
    ProtoBuf.metalock() do
        if !isassigned(__meta_Transaction_Res)
            __meta_Transaction_Res[] = target = ProtoMeta(Transaction_Res)
            fnum = Int[1,2,4,5,6,7,8,9,10,11,12,13]
            allflds = Pair{Symbol,Union{Type,String}}[:id => AbstractString, :done => Bool, :_continue => Bool, :open_res => Transaction_Open_Res, :commit_res => Transaction_Commit_Res, :rollback_res => Transaction_Rollback_Res, :query_res => Query_Res, :concept_manager_res => ConceptManager_Res, :thing_res => Thing_Res, :type_res => Type_Res, :logic_manager_res => LogicManager_Res, :rule_res => Rule_Res]
            oneofs = Int[0,1,1,1,1,1,1,1,1,1,1,1]
            oneof_names = Symbol[Symbol("res")]
            meta(target, Transaction_Res, allflds, ProtoBuf.DEF_REQ, fnum, ProtoBuf.DEF_VAL, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, oneofs, oneof_names)
        end
        __meta_Transaction_Res[]
    end
end
function Base.getproperty(obj::Transaction_Res, name::Symbol)
    if name === :id
        return (obj.__protobuf_jl_internal_values[name])::AbstractString
    elseif name === :done
        return (obj.__protobuf_jl_internal_values[name])::Bool
    elseif name === :_continue
        return (obj.__protobuf_jl_internal_values[name])::Bool
    elseif name === :open_res
        return (obj.__protobuf_jl_internal_values[name])::Transaction_Open_Res
    elseif name === :commit_res
        return (obj.__protobuf_jl_internal_values[name])::Transaction_Commit_Res
    elseif name === :rollback_res
        return (obj.__protobuf_jl_internal_values[name])::Transaction_Rollback_Res
    elseif name === :query_res
        return (obj.__protobuf_jl_internal_values[name])::Query_Res
    elseif name === :concept_manager_res
        return (obj.__protobuf_jl_internal_values[name])::ConceptManager_Res
    elseif name === :thing_res
        return (obj.__protobuf_jl_internal_values[name])::Thing_Res
    elseif name === :type_res
        return (obj.__protobuf_jl_internal_values[name])::Type_Res
    elseif name === :logic_manager_res
        return (obj.__protobuf_jl_internal_values[name])::LogicManager_Res
    elseif name === :rule_res
        return (obj.__protobuf_jl_internal_values[name])::Rule_Res
    else
        getfield(obj, name)
    end
end

mutable struct Transaction_Rollback <: ProtoType
    __protobuf_jl_internal_meta::ProtoMeta
    __protobuf_jl_internal_values::Dict{Symbol,Any}
    __protobuf_jl_internal_defaultset::Set{Symbol}

    function Transaction_Rollback(; kwargs...)
        obj = new(meta(Transaction_Rollback), Dict{Symbol,Any}(), Set{Symbol}())
        values = obj.__protobuf_jl_internal_values
        symdict = obj.__protobuf_jl_internal_meta.symdict
        for nv in kwargs
            fldname, fldval = nv
            fldtype = symdict[fldname].jtyp
            (fldname in keys(symdict)) || error(string(typeof(obj), " has no field with name ", fldname))
            values[fldname] = isa(fldval, fldtype) ? fldval : convert(fldtype, fldval)
        end
        obj
    end
end # mutable struct Transaction_Rollback
const __meta_Transaction_Rollback = Ref{ProtoMeta}()
function meta(::Type{Transaction_Rollback})
    ProtoBuf.metalock() do
        if !isassigned(__meta_Transaction_Rollback)
            __meta_Transaction_Rollback[] = target = ProtoMeta(Transaction_Rollback)
            allflds = Pair{Symbol,Union{Type,String}}[]
            meta(target, Transaction_Rollback, allflds, ProtoBuf.DEF_REQ, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
        end
        __meta_Transaction_Rollback[]
    end
end

mutable struct Transaction <: ProtoType
    __protobuf_jl_internal_meta::ProtoMeta
    __protobuf_jl_internal_values::Dict{Symbol,Any}
    __protobuf_jl_internal_defaultset::Set{Symbol}

    function Transaction(; kwargs...)
        obj = new(meta(Transaction), Dict{Symbol,Any}(), Set{Symbol}())
        values = obj.__protobuf_jl_internal_values
        symdict = obj.__protobuf_jl_internal_meta.symdict
        for nv in kwargs
            fldname, fldval = nv
            fldtype = symdict[fldname].jtyp
            (fldname in keys(symdict)) || error(string(typeof(obj), " has no field with name ", fldname))
            values[fldname] = isa(fldval, fldtype) ? fldval : convert(fldtype, fldval)
        end
        obj
    end
end # mutable struct Transaction
const __meta_Transaction = Ref{ProtoMeta}()
function meta(::Type{Transaction})
    ProtoBuf.metalock() do
        if !isassigned(__meta_Transaction)
            __meta_Transaction[] = target = ProtoMeta(Transaction)
            allflds = Pair{Symbol,Union{Type,String}}[]
            meta(target, Transaction, allflds, ProtoBuf.DEF_REQ, ProtoBuf.DEF_FNUM, ProtoBuf.DEF_VAL, ProtoBuf.DEF_PACK, ProtoBuf.DEF_WTYPES, ProtoBuf.DEF_ONEOFS, ProtoBuf.DEF_ONEOF_NAMES)
        end
        __meta_Transaction[]
    end
end

export Transaction_Type, Transaction_Req_MetadataEntry, Transaction_Req, Transaction_Res, Transaction_Open_Req, Transaction_Open_Res, Transaction_Open, Transaction_Commit_Req, Transaction_Commit_Res, Transaction_Commit, Transaction_Rollback_Req, Transaction_Rollback_Res, Transaction_Rollback, Transaction
# mapentries: "Transaction_Req_MetadataEntry" => ("AbstractString", "AbstractString")
