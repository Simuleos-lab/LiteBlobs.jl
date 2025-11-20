# Core types
# TODO: Add type parameters
abstract type AbstractLiteObj end
abstract type AbstractLiteBlob <: AbstractLiteObj end
abstract type AbstractBlobArray <: AbstractLiteObj end

# TODO/TAI Is this needed?
abstract type AbstractBlobDict end

# A dict like struct
struct LiteBlob <: AbstractLiteBlob
    # primary storage (Lite "standard")
    __depot__::OrderedDict{String,Any}

    # runtime-only extras
    # - for instance, for implementing a dynamic struct
    __extras__::Dict{String,Any}
end

LiteBlob() = LiteBlob(OrderedDict(), Dict())

# A vector of liteblobs
struct LiteBlobArray{T<:AbstractLiteBlob} <: AbstractBlobArray
    __depot__::Vector{T}
    __extras__::Dict{String,Any}
end

# Convenience: allow construction from just a vector
function LiteBlobArray(
    depot::Vector{T}
) where {T<:AbstractLiteBlob}
    LiteBlobArray{T}(depot, Dict())
end

LiteBlobArray{T}() where {T<:AbstractLiteBlob} = 
    LiteBlobArray(Vector{T}())