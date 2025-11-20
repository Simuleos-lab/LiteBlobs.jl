############################
# MARK: Array interface
############################

lite_size(A::AbstractBlobArray) = 
    _lite_size(A)

# Basic standard array/dict interface
lite_getindex(A::AbstractBlobArray, I...) = 
    _lite_getindex(A, I...)
    
# It's good practice to declare index style for performance on some code paths.
lite_IndexStyle(x::Type{<:AbstractBlobArray}) =
    _lite_IndexStyle(x)

# Axes helps generic array code (works with arbitrary dimensions).
lite_axes(A::AbstractBlobArray) = 
    _lite_axes(A)

# Optional but handy
lite_length(A::AbstractBlobArray) = 
    _lite_length(A)

# Iteration over arrays defaults to eachindex + getindex, but we can forward.
lite_iterate(A::AbstractBlobArray, state=1) = 
    _lite_iterate(A, state)

############################
# MARK: Utils
############################

lite_eltype(x::Type{AbstractBlobArray}) = 
    _lite_eltype(x)

# --- Simple mutating utilities ---

lite_push!(
    B::AbstractBlobArray,
    x::AbstractLiteBlob
) = _lite_push!(B, x)

lite_pop!(B::AbstractBlobArray) = 
    _lite_pop!(B)

lite_empty!(x::AbstractBlobArray) =
    _lite_empty!(x)

# --- rand interface (Random stdlib) ---

# Return a random element from the bag (throws if empty, like rand on an empty collection).
lite_rand(rng::AbstractRNG, B::AbstractBlobArray) = 
    _lite_rand(rng, B)

lite_rand(B::AbstractBlobArray) = 
    _lite_rand(B)

# Also useful: sample multiple elements
lite_rand(rng::AbstractRNG,
    B::AbstractBlobArray, n::Integer
) = _lite_rand(rng, B, n)

lite_rand(B::AbstractBlobArray, n::Integer) = 
    _lite_rand(B, n)


# # If you want sampling *without* replacement, add this:
# lite_rand(rng::AbstractRNG,
#     T2::Random.SamplerType{AbstractBlobArray},
#     B::AbstractBlobArray,
#     T3::Random.SamplerTrivial,
#     n::Random.SamplerTrivial
# )
#     # (Kept intentionally simple—prefer `sample` from StatsBase for serious work.)
#     error("Sampling without replacement not implemented for AbstractBlobArray; use StatsBase.sample if needed.")

