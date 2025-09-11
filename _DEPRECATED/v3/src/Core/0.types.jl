## -..-.. . .- -- - . . . ..-.. .- .- - .-- .-...- 
# Abstracts
abstract type AbstractLiteObject end
abstract type AbstractLiteBlob <: AbstractLiteObject end
abstract type AbstractLiteNode <: AbstractLiteObject end

## -..-.. . .- -- - . . . ..-.. .- .- - .-- .-...- 
# - `RootBlob`
#     - The root of the tree
#     - RootBlob -> AbstractLiteBlob -> AbstractLiteNode -> LiteData
struct RootBlob
    path::String
    extras::Dict{String, Any}
end

RootBlob(path::String) = RootBlob(path, Dict())


## -..-.. . .- -- - . . . ..-.. .- .- - .-- .-...- 
# - FreeBlob
#   - file-less blob
#   - no parents
#   - implement the lite protocole
#   - it contains its own repo
struct FreeBlob <: AbstractLiteBlob
    depot::Dict{String, Any}
    extras::Dict{String, Any}
end

## -..-.. . .- -- - . . . ..-.. .- .- - .-- .-...- 
# - `DynamicBlob`
#   - random-hash in the name
#   - mutable
#   - its file can be deleted
struct DynamicBlob <: AbstractLiteBlob
    parent::RootBlob
    name::String
    depot::Vector{AbstractDict}
    extras::Dict{String, Any}
end

DynamicBlob(parent::RootBlob, name::String, depot) = 
    DynamicBlob(parent, name, depot, Dict())

# - `StaticBlob`
#     - content-hash in the name
#     - readonly
#     - file can't be deleted using API
#       - maybe just on blob merging
#     - a committed blob
#     - you keep what you commit
struct StaticBlob <: AbstractLiteBlob
    parent::RootBlob
    name::String
    depot::Vector{AbstractDict}
    extras::Dict{String, Any}
end

StaticBlob(parent::RootBlob, name::String, depot) = 
    StaticBlob(parent, name, depot, Dict())


# NOTE
# - getindex
# - All path resolutions must
# - resolve to the same depot object
# - A single data source principle


# - `DynamicNode`
# - nodes of `DynamicBlob`s
struct DynamicNode <: AbstractLiteNode
    parent::DynamicBlob
    depot::Dict{String, Any} # same object as DynamicBlob
    path::Dict{String, Any}
end


# - `StaticNode`
# - nodes of `StaticBlob`s
struct StaticNode <: AbstractLiteNode
    parent::StaticBlob
    depot::Dict{String, Any}    # same object as in blobs depot
    path::Dict{String, Any}     # the path on the blob tree
end

## -..-.. . .- -- - . . . ..-.. .- .- - .-- .-...- 
# - FreeNode
#   - file-less blob
#   - no parents
#   - no validators
#   - just a dict wrapper
#   - implement the lite protocole
#   - it contains its own repo
struct FreeNode <: AbstractLiteNode
    depot::Dict{String, Any}
end

## -..-.. . .- -- - . . . ..-.. .- .- - .-- .-...- 
# #NOTE
# # inter-blob links/refs
# - I can easily references data (node/query)
# - So I can use them for operations
# - For instance
#   - two blobs sharing 99% of key:pairs equals
#   - I write one completely 
#   - and for the next I store a `diff-node`









# ## --.- .- . -.- - . . . -.- . - -- - -- . .,.-. -
# MARK: VERSION 2025-08-30

# ## --.- .- . -.- - . . . -.- . - -- - -- . .,.-. -
# # # Disc
# # RootNode
# #   |- LiteBlob.ljsonl
# #   |   |- LiteNode
# #   |   |   |- "key": val
# #   |   |   |- ...
# #   |   |   
# #   |   |- LiteNode ...
# #   |   |- LiteNode ...
# #   |   |- LiteNode ...
# #   |   |- LiteNode ...
# #   |   |   
# #   |  
# #   |- LiteBlob.ljsonl ...
# #   |- LiteBlob.ljsonl ...
# #   |- LiteBlob.ljsonl ...
# #   |  
# #   |- # subfolders are ignored

# ## --.- .- . -.- - . . . -.- . - -- - -- . .,.-. -
# # # RAM
# # Just a fancy path object
# struct RootNode
#   path::String
#   # #NOTE: we need to be able to control (enable) the cache process
#   # LRU{String, Int}(maxsize=200)  # max 200 elements
#   cache::LRU{String, Any}
#   extras::Dict{String, Any}
# end

# RootNode(path::String; maxsize=200) = RootNode(path, 
#   LRU{String, Any}(;maxsize), 
#   Dict{String, Any}()
# )

# # Abstracts
# # An object that implements TheLiteStandard
# abstract type AbstractLiteBlob end
# abstract type AbstractLiteNode end

# # - base type
# # - mutable
# struct LiteBlob <: AbstractLiteBlob
#     parent::RootNode
#     depot::Vector{AbstractLiteNode}
# end
# LiteBlob(p::RootNode) = LiteBlob(p, [])

# # - A blob that is verified on construction (TAI)
# # - readonly
# struct HashedBlob <: AbstractLiteBlob
#     parent::RootNode
#     depot::Vector{AbstractLiteNode}
# end
# HashedBlob(p::RootNode) = HashedBlob(p, [])

# # #BEST-PRACTICE
# # - the fisrt time a variable is used
# # - that was extracted from a LiteNode
# # - the type should be asserted
# # - For instace
# # @import node
# # b = a::Float64 
# # # I know that `a` is injected from the `node`
# # Data is in blob object
# # - one only source/depot of data
# struct LiteNode
#     parent::AbstractLiteBlob
#     idx::Int
# end

# LiteNode(p::AbstractLiteBlob) = LiteNode(p, pushindex(p, idx))

# # #TODO: make HashNode too

# # How to create a LiteNode?
# # - two cases
# # - i. ondemand
# #       - data is created on demand
# #       - either a getindex or a setindex!
# #       - if the index is not there yet
# #           - extend the vector appropiatly
# #
# #
# # - ii. bang version
# #   - where the LiteNode is created by user request

# # #TODO/TAI Multithreading
# # - All threads has it machinary
# # - there are commands that run in all threads if call in one
# # - others are only local
# #
# # - another, lock key actions
# #   - push!, commit!, reset!
# #

# # LiteNode 
# # - will be the must used object
# # - It needs to be easy to jump 
# #   - from an object `LiteNode`
# #   - to the julia scope
# #       - @importn/@exportn
# #

# # NOTE
# # - diff-hash
# #   - the hash of all after filtering
# #   - this can be use as a validation notice
# #       - folder can be merge
# #           - it is not useful to hash the folder
# #           - you will need to list them
# #           - in this case the hash is not useful
# # - 
# # - 

# # NOTE
# # # HashMask
# # - the hash of an object but after applaying a filter(s)
# #

