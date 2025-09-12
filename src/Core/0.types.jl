# Core types
# TODO: Add type parameters
abstract type AbstractLiteBlob end

# A dict like struct
struct LiteBlob <: AbstractLiteBlob
    # primary storage (Lite "standard")
    __depot__::OrderedDict{String, Any}   
    
    # runtime-only extras
    # Implement dynamic struct
    __extras__::Dict{String, Any}  
end

LiteBlob() = LiteBlob(OrderedDict(), Dict())
