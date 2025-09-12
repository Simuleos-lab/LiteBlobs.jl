# TheLiteStandard

## Tier 0

- is a key value dictionary-like object. 
    - key types 
        - `string` 
    - value types 
        - `string` 
        - `number` 
        - short `arrays` 
        - similar `objects` 
- It needs to be representable/encoded as a valid json file.
    - without lost of information.

## LiteBlobs

- **LiteBlobs.jl** is a **Tier 0** implementation
- It defines interfaces to be use by Julia applications/packages.
- It aims to make the object as flexible and useful as possible.
- for instance, nice querying system


## Usage

`LiteBlob` is a lightweight key–value container that behaves like a dictionary but is extensible for custom blob types.

### Creating a LiteBlob

```julia
using MyLiteBlobPackage  # replace with your package/module name

# Empty blob
b = LiteBlob()

# Construct from Dict
b = LiteBlob(Dict("a" => 1, "b" => 2))

# Construct from pairs
b = LiteBlob(["x" => 42, "y" => 99])

# Construct from NamedTuple
b = LiteBlob((foo = "bar", spam = 123))
````

### Basic Operations

```julia
# Setting and getting values
b["a"] = 1
b["b"] = 2
@show b["a"]      # 1

# Check if a key exists
@show haskey(b, "a")  # true

# Delete a key
delete!(b, "a")

# Get with default
val = get(b, "missing", 0)  # returns 0 if not found

# Merge with another Dict or blob
merge!(b, Dict("z" => 100))
```

### Iteration

`LiteBlob` supports the standard Julia iteration interface and yields `Pair{String,Any}` objects:

```julia
for (k, v) in b
    println("key=$k, value=$v")
end

for kv in b
    @show kv  # kv is a Pair
end
```

You can also get `keys`, `values`, and `pairs` just like a normal `Dict`:

```julia
ks = keys(b)
vs = values(b)
ps = pairs(b)
```

### Convenience Helpers

Optional positional access helpers:

```julia
nth = lite_nthkey(b, 1)     # get the first key
nthp = lite_nthpair(b, 1)   # get the first key=>value pair
```

### Extending for Custom Blobs

To define a custom subtype with the same dictionary-like behavior, just implement `blob_dict(::YourType)`:

```julia
struct MyBlob <: AbstractLiteBlob
    store::Dict{String,Any}
end

blob_dict(x::MyBlob) = x.store

# MyBlob now supports getindex, setindex!, iteration, etc.
mb = MyBlob(Dict("foo" => 1))
@show mb["foo"]  # works just like LiteBlob
```

This design makes it easy to create specialized blobs while automatically inheriting all dictionary-like operations.
