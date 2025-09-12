# Core types
# TODO: Add type parameters
abstract type AbstractLiteBlob end
abstract type AbstractLiteBatch end

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

struct LiteBatch <: AbstractLiteBatch
    __depot__::Vector{LiteBlob}
    __extras__::Dict{String, Any}
end

LiteBatch() = LiteBatch([], Dict())

