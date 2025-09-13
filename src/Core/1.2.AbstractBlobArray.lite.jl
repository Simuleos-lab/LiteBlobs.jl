############################
# MARK: Array interface
############################

function lite_size(A::AbstractBlobArray)
    # Forward to the wrapped array's size.
    return size(__depot__(A))
end

# Basic standard array/dict interface
function lite_getindex(A::AbstractBlobArray, I...)
    # Read element(s) from the wrapped array.
    return getindex(__depot__(A), I...)
end

# It's good practice to declare index style for performance on some code paths.
function lite_IndexStyle(::Type{<:AbstractBlobArray})
    # Match standard arrays: linear indexing is supported.
    return IndexLinear()
end

# Axes helps generic array code (works with arbitrary dimensions).
function lite_axes(A::AbstractBlobArray)
    # Forward axes of the wrapped array.
    return axes(__depot__(A))
end

# Optional but handy
function lite_length(A::AbstractBlobArray)
    # Total number of elements (product of dimensions).
    return length(__depot__(A))
end

# Iteration over arrays defaults to eachindex + getindex, but we can forward.
function lite_iterate(A::AbstractBlobArray, state=1)
    # Simple linear iteration over elements.
    state > length(A) && return nothing
    return (A[state], state + 1)
end

function Base.show(io::IO, A::AbstractBlobArray)
    # Pretty-ish display that shows it's a wrapper and prints data.
    print(io, "AbstractBlobArray(", length(A), ")")
end

############################
# MARK: Utils
############################

function Base.eltype(::Type{AbstractBlobArray})
    return AbstractLiteBlob
end

# --- Simple mutating utilities ---

function lite_push!(
    B::AbstractBlobArray,
    x::AbstractLiteBlob
)
    return push!(__depot__(B), x)
end

function lite_pop!(B::AbstractBlobArray)
    return pop!(__depot__(B))
end


# --- rand interface (Random stdlib) ---

# Return a random element from the bag (throws if empty, like rand on an empty collection).
function lite_rand(rng::AbstractRNG, B::AbstractBlobArray)
    # Pick a uniformly random element by random index.
    @assert !isempty(__depot__(B)) "rand(::AbstractBlobArray): cannot sample from an empty AbstractBlobArray"
    return rand(rng, __depot__(B))
end

function lite_rand(B::AbstractBlobArray)
    # RNG-default convenience method.
    return rand(Random.default_rng(), B)
end

# Also useful: sample multiple elements
function lite_rand(rng::AbstractRNG,
    B::AbstractBlobArray, n::Integer
)
    return rand(rng, __depot__(B), n)
end

function lite_rand(B::AbstractBlobArray, n::Integer)
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
