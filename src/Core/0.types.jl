# Core types
# TODO: Add type parameters
abstract type AbstractLiteObj end
abstract type AbstractLiteBlob <: AbstractLiteObj end
abstract type AbstractBlobArray <: AbstractLiteObj end

# TODO/TAI Is this need it?
abstract type AbstractBlobDict end

# A dict like struct
struct LiteBlob <: AbstractLiteBlob
    # primary storage (Lite "standard")
    __depot__::OrderedDict{String, Any}   
    
    # runtime-only extras
    # - for instance, for implementing a dynamic struct
    __extras__::Dict{String, Any}  
end

LiteBlob() = LiteBlob(OrderedDict(), Dict())

# A vector of liteblobs
# Behave as an OrderedSet object
# - it is implemented as an OrderedDict to 

struct BlobArray <: AbstractBlobArray
    __depot__::Vector{AbstractLiteBlob}
    __extras__::Dict{String, Any}
end

BlobArray() = BlobArray([], Dict())

