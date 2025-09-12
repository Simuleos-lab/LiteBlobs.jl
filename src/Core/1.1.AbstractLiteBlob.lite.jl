# TODO/TAI
# Think about a callback system for opening
# the getindex interface to any (custom) query resolver

# get / set by key
function lite_getindex_I(x::AbstractLiteBlob,
    k::String
)
    return getindex(__depot__(x), k)
end
function lite_getindex_I(x::AbstractLiteBlob,
    ::typeof(^), k::String
)
    return getindex(__extras__(x), k)
end

function lite_setindex_I!(
    x::AbstractLiteBlob, v,
    k::String,
    ks...
)
    return Base.setindex!(__depot__(x), v, k, ks...)
end

function lite_setindex_I!(
    x::AbstractLiteBlob, v,
    ::typeof(^),
    k::String
)
    return Base.setindex!(__extras__(x), v, k)
end

# haskey / get with default / delete / empty
function lite_haskey(x::AbstractLiteBlob, k::String)
    return haskey(__depot__(x), k)
end

function lite_get(x::AbstractLiteBlob, k::String, default)
    return get(__depot__(x), k, default)
end
function lite_get(f::Function, x::AbstractLiteBlob, k::String)
    return get(f, __depot__(x), k)
end

function lite_get!(x::AbstractLiteBlob, k::String, default)
    return get!(__depot__(x), k, default)
end
function lite_get!(f::Function, x::AbstractLiteBlob, k::String)
    return get!(f, __depot__(x), k)
end


function lite_delete!(x::AbstractLiteBlob, k::String)
    delete!(__depot__(x), k)
end
function lite_empty!(x::AbstractLiteBlob)
    empty!(__depot__(x))
end

# merge / merge!
# TODO: Think about merging
function lite_merge!(x::AbstractLiteBlob, it)
    merge!(__depot__(x), it)
    return x
end

# TODO: think more this
function lite_merge(x::AbstractLiteBlob, it)
    depot1 = merge(__depot__(x), it)
    extras1 = copy(__extras__(x))
    return LiteBlob(depot1, extras1)
end

# length / keys / values / pairs
function lite_length(x::AbstractLiteBlob)
    return length(__depot__(x))
end
function lite_keys(x::AbstractLiteBlob)
    return keys(__depot__(x))
end
function lite_values(x::AbstractLiteBlob)
    return values(__depot__(x))
end
function lite_pairs(x::AbstractLiteBlob)
    return pairs(__depot__(x))
end

# membership (e.g., "k in blob" checks keys)
function lite_in(k::String, x::AbstractLiteBlob)
    return in(k, keys(x))
end

# iteration yields (key => value) pairs
# Note: iteration protocol is `iterate(obj[, state])`.
function lite_iterate(x::AbstractLiteBlob)
    return iterate(pairs(__depot__(x)))
end
function lite_iterate(x::AbstractLiteBlob, state)
    return iterate(pairs(__depot__(x)), state)
end

# eltype for iteration (what does each iteration yield?)
function lite_eltype(T::Type{<:AbstractLiteBlob})
    return Pair{string,Any}
end


# --- Optional: a simple "array-like" view -------------------------------------
# If you want index-by-position access (not typical for dicts, but sometimes handy),
# provide a *view* that’s explicit, so it’s not surprising.
# Example: nth key or nth Pair. These are just helpers; they don’t claim an array API.

# nth key (1-based)
function lite_nthkey(x::AbstractLiteBlob, i0::Integer)
    i = 1
    for k in keys(x)
        i == i0 && return k
        i += 1
    end
    # TODO: make this pro
    return error("Index out of bound")
end

# nth pair
function lite_nthpair(x::AbstractLiteBlob, i0::Integer)
    i = 1
    for p in x
        i == i0 && return p
        i += 1
    end
    # TODO: make this pro
    return error("Index out of bound")
end

# --- json ------------------------------------------------------------------
# MARK: json
function lite_json(x::AbstractLiteBlob)
    js = JSON3.write(__depot__(x))
    return js
end

function _esc_newline(js::String)
    js = replace(js, "\n" => "\\n")
    return js
end

# Produce a json representation but in a single line
# Escape new lines if necesary
function lite_jsonline(x::AbstractLiteBlob; esc_newline=false)
    js = JSON.json(__depot__(x), 0)
    if esc_newline
        js = _esc_newline(js)
    end
    return js
end


# --- Example ------------------------------------------------------------------
# b = LiteBlob()
# b["a"] = 1
# b["b"] = 2
# @show haskey(b, "a")      # true
# @show length(b)           # 2
# for kv in b               # iterates key=>value pairs
#     @show kv
# end
# @show lite_nthkey(b, 1)
# delete!(b, "a")
