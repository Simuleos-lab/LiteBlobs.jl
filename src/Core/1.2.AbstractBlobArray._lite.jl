# - notes at AbstractLiteBlob._lite also apply here

############################
# MARK: Array interface
############################

function _lite_size(A::AbstractBlobArray)
    # Forward to the wrapped array's size.
    return size(__depot__(A))
end

# Basic standard array/dict interface
function _lite_getindex(A::AbstractBlobArray, I...)
    # Read element(s) from the wrapped array.
    return getindex(__depot__(A), I...)
end

# It's good practice to declare index style for performance on some code paths.
function _lite_IndexStyle(::Type{<:AbstractBlobArray})
    # Match standard arrays: linear indexing is supported.
    return IndexLinear()
end

# Axes helps generic array code (works with arbitrary dimensions).
function _lite_axes(A::AbstractBlobArray)
    # Forward axes of the wrapped array.
    return axes(__depot__(A))
end

# Optional but handy
function _lite_length(A::AbstractBlobArray)
    # Total number of elements (product of dimensions).
    return length(__depot__(A))
end

# Iteration over arrays defaults to eachindex + getindex, but we can forward.
function _lite_iterate(A::AbstractBlobArray, state=1)
    # Simple linear iteration over elements.
    state > _lite_length(A) && return nothing
    val = _lite_getindex(A, state)
    return (val, state + 1)
end

############################
# MARK: Utils
############################

function _lite_eltype(::Type{AbstractBlobArray})
    return AbstractLiteBlob
end

# --- Simple mutating utilities ---

function _lite_push!(
    B::AbstractBlobArray,
    x::AbstractLiteBlob
)
    return push!(__depot__(B), x)
end

function _lite_pop!(B::AbstractBlobArray)
    return pop!(__depot__(B))
end

function _lite_empty!(x::AbstractBlobArray)
    empty!(__depot__(x))
end

# --- rand interface (Random stdlib) ---

# Return a random element from the bag (throws if empty, like rand on an empty collection).
function _lite_rand(rng::AbstractRNG, B::AbstractBlobArray)
    # Pick a uniformly random element by random index.
    @assert !_lite_isempty(B) "rand(::AbstractBlobArray): cannot sample from an empty AbstractBlobArray"
    return rand(rng, __depot__(B))
end

function _lite_rand(B::AbstractBlobArray)
    # RNG-default convenience method.
    return rand(Random.default_rng(), B)
end

# Also useful: sample multiple elements
function _lite_rand(rng::AbstractRNG,
    B::AbstractBlobArray, n::Integer
)
    return rand(rng, __depot__(B), n)
end

function _lite_rand(B::AbstractBlobArray, n::Integer)
    # RNG-default convenience method.
    return rand(Random.default_rng(), B, n)
end

# # If you want sampling *without* replacement, add this:
# function lite_rand(rng::AbstractRNG,
#     T2::Random.SamplerType{AbstractBlobArray},
#     B::AbstractBlobArray,
#     T3::Random.SamplerTrivial,
#     n::Random.SamplerTrivial
# )
#     # (Kept intentionally simple—prefer `sample` from StatsBase for serious work.)
#     error("Sampling without replacement not implemented for AbstractBlobArray; use StatsBase.sample if needed.")
# end
