############################
# MARK: Array interface
############################

# --- Required Array interface methods ---

function lite_size(A::AbstractBlobArray)
    # Forward to the wrapped array's size.
    return size(__depot__(A))
end


function lite_getindex(A::AbstractBlobArray, I...)
    # Read element(s) from the wrapped array.
    return getindex(__depot__(A), I...)
end

function lite_setindex!(A::AbstractBlobArray, v, I...)
    # Write element(s) into the wrapped array.
    setindex!(__depot__(A), v, I...)
    return A
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

# Create a similar container for generic array-creating code.
function lite_similar(A::AbstractBlobArray,
    ::Type{S}, dims::Dims
) where {S}
    # Make a wrapper around a new Array of the requested element type/shape.
    return AbstractBlobArray{S,length(dims)}(similar(__depot__(A), S, dims))
end

# Iteration over arrays defaults to eachindex + getindex, but we can forward.
function lite_iterate(A::AbstractBlobArray, state=1)
    # Simple linear iteration over elements.
    state > length(A) && return nothing
    return (A[state], state + 1)
end

# A couple of convenience utilities
function lite_copy(A::AbstractBlobArray)
    # Deep copy the underlying array into a fresh wrapper.
    return AbstractBlobArray(copy(__depot__(A)))
end

function Base.show(io::IO, A::AbstractBlobArray)
    # Pretty-ish display that shows it's a wrapper and prints data.
    print(io, "AbstractBlobArray(", repr(__depot__(A)), ")")
end


############################
# MARK: Dict interface
############################


# Recommended helpers to feel like a normal Dict

function lite_haskey(D::AbstractBlobArray, k)
    # True if key exists.
    return haskey(__depot__(D), k)
end

function lite_keys(D::AbstractBlobArray)
    # Iterator over keys.
    return keys(__depot__(D))
end

function lite_values(D::AbstractBlobArray)
    # Iterator over values.
    return values(__depot__(D))
end

function lite_pairs(D::AbstractBlobArray)
    # Iterator over Pair(k,v).
    return pairs(__depot__(D))
end

function lite_delete!(D::AbstractBlobArray, k)
    # Remove a key if present.
    delete!(__depot__(D), k)
    return D
end

function lite_empty!(D::AbstractBlobArray)
    # Remove all entries.
    empty!(__depot__(D))
    return D
end

function lite_get(D::AbstractBlobArray, k, default)
    # Return value if present, otherwise `default`.
    return get(__depot__(D), k, default)
end

function lite_get!(D::AbstractBlobArray, k, default)
    # Return existing value or insert default and return it.
    return get!(__depot__(D), k, default)
end


############################
# MARK: Utils
############################

function Base.eltype(::Type{AbstractBlobArray})
    return AbstractLiteBlob
end

# --- Simple mutating utilities ---

function lite_push!(B::AbstractBlobArray, x)
    # Add an element to the bag.
    push!(__depot__(B), x)
    return B
end

function lite_pop!(B::AbstractBlobArray)
    # Remove and return the last element.
    return pop!(__depot__(B))
end


# --- rand interface (Random stdlib) ---

# Return a random element from the bag (throws if empty, like rand on an empty collection).
function lite_rand(rng::AbstractRNG, B::AbstractBlobArray)
    # Pick a uniformly random element by random index.
    @assert !isempty(__depot__(B)) "rand(::AbstractBlobArray): cannot sample from an empty AbstractBlobArray"
    return __depot__(B)[rand(rng, eachindex(__depot__(B)))]
end

function lite_rand(B::AbstractBlobArray)
    # RNG-default convenience method.
    return rand(Random.default_rng(), B)
end

# Also useful: sample multiple elements
function lite_rand(rng::AbstractRNG, B::AbstractBlobArray, n::Integer)
    # Return a Vector{T} of n samples with replacement.
    @assert !isempty(__depot__(B)) "rand(::AbstractBlobArray, n): cannot sample from an empty AbstractBlobArray"
    idxs = rand(rng, eachindex(__depot__(B)), n)  # random indices with replacement
    return __depot__(B)[idxs]
end

function lite_rand(B::AbstractBlobArray, n::Integer)
    # RNG-default convenience method.
    return rand(Random.default_rng(), B, n)
end

# If you want sampling *without* replacement, add this:
function lite_rand(rng::AbstractRNG,
    T2::Random.SamplerType{AbstractBlobArray}, 
    B::AbstractBlobArray,
    T3::Random.SamplerTrivial,
    n::Random.SamplerTrivial
)
    # (Kept intentionally simple—prefer `sample` from StatsBase for serious work.)
    error("Sampling without replacement not implemented for AbstractBlobArray; use StatsBase.sample if needed.")
end
