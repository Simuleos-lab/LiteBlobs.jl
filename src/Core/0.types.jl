# Core types
abstract type AbstractLiteBlob end

struct LiteBlob <: AbstractLiteBlob
    depot::OrderedDict{String, Any}   # primary storage (Lite "standard")
    extras::OrderedDict{String, Any}  # runtime-only extras
end

