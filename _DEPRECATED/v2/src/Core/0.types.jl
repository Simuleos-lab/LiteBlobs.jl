## --.- .- . -.- - . . . -.- . - -- - -- . .,.-. -
# # Disc
# RootNode
#   |- LiteBlob.ljsonl
#   |   |- LiteNode
#   |   |   |- "key": val
#   |   |   |- ...
#   |   |   
#   |   |- LiteNode ...
#   |   |- LiteNode ...
#   |   |- LiteNode ...
#   |   |- LiteNode ...
#   |   |   
#   |  
#   |- LiteBlob.ljsonl ...
#   |- LiteBlob.ljsonl ...
#   |- LiteBlob.ljsonl ...
#   |  
#   |- # subfolders are ignored

## --.- .- . -.- - . . . -.- . - -- - -- . .,.-. -
# # RAM
# Just a fancy path object
struct RootNode
  path::String
  # #NOTE: we need to be able to control (enable) the cache process
  # LRU{String, Int}(maxsize=200)  # max 200 elements
  cache::LRU{String, Any}
  extras::Dict{String, Any}
end

RootNode(path::String; maxsize=200) = RootNode(path, 
  LRU{String, Any}(;maxsize), 
  Dict{String, Any}()
)

# Abstracts
# An object that implements TheLiteStandard
abstract type AbstractLiteBlob end
abstract type AbstractLiteNode end

# - base type
# - mutable
struct LiteBlob <: AbstractLiteBlob
    parent::RootNode
    depot::Vector{AbstractLiteNode}
end
LiteBlob(p::RootNode) = LiteBlob(p, [])

# - A blob that is verified on construction (TAI)
# - readonly
struct HashedBlob <: AbstractLiteBlob
    parent::RootNode
    depot::Vector{AbstractLiteNode}
end
HashedBlob(p::RootNode) = HashedBlob(p, [])

# #BEST-PRACTICE
# - the fisrt time a variable is used
# - that was extracted from a LiteNode
# - the type should be asserted
# - For instace
# @import node
# b = a::Float64 
# # I know that `a` is injected from the `node`
# Data is in blob object
# - one only source/depot of data
struct LiteNode
    parent::AbstractLiteBlob
    idx::Int
end

LiteNode(p::AbstractLiteBlob) = LiteNode(p, pushindex(p, idx))

# #TODO: make HashNode too

# How to create a LiteNode?
# - two cases
# - i. ondemand
#       - data is created on demand
#       - either a getindex or a setindex!
#       - if the index is not there yet
#           - extend the vector appropiatly
#
#
# - ii. bang version
#   - where the LiteNode is created by user request

# #TODO/TAI Multithreading
# - All threads has it machinary
# - there are commands that run in all threads if call in one
# - others are only local
#
# - another, lock key actions
#   - push!, commit!, reset!
#

# LiteNode 
# - will be the must used object
# - It needs to be easy to jump 
#   - from an object `LiteNode`
#   - to the julia scope
#       - @importn/@exportn
#

# NOTE
# - diff-hash
#   - the hash of all after filtering
#   - this can be use as a validation notice
#       - folder can be merge
#           - it is not useful to hash the folder
#           - you will need to list them
#           - in this case the hash is not useful
# - 
# - 

# NOTE
# # HashMask
# - the hash of an object but after applaying a filter(s)
#

