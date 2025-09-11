# .- . . .- - - - - - .. . . .. - -... . .. 
# # Full read interface
# - read will be total
# - At the end it returns 
#   - the parsed JSON depot
#   - the validation hashes
# - callback interface
#   - onstart
#   - online
#   - oneof

# .- . . .- - - - - - .. . . .. - -... . .. 










# # ---..- . - .-... . -- -- .. . .- -..
# # # Blob live cycle
# # - (file, filename) -> [loader] -> JSONLinesBlob
# # - JSONLinesBlob -> [parser]
# # - [parser] -> [hash is valid] -> StaticBlob
# # - [parser] -> [hash is random] -> DynamicBlob
# # - DynamicBlob -> [commiter]
# # - [commiter] -> StaticBlob 
# # - 2x StaticBlob -> [merger]
# # - [merger] -> StaticBlob
# # - AbstractFileBlob -> [writer]
# # - [writer] -> [resolve hash] -> (file, filename)

# # ---..- . - .-... . -- -- .. . .- -..
# using Base.Threads
# # raw read of the whole file
# function _read_blob_depot(path::String)

#     depot_ths = Dict{
#         Int, # theadid
#         Dict{Int, Dict{String, Any}}
#     }()
    
#     open(path, "r") do io
#         # TODO exporse 
#         cn_size = 10
#         lines_ch = Channel{Tuple{Int, String}}(cn_size) do _ch
#             iter = enumerate(eachline(io))
#             for (li, line) in iter
#                put!(_ch, (li, line))
#             end
#         end

#         # TODO exporse 
#         th_num = 10
#         lk = ReentrantLock()
#         @threads :static for thid in 1:th_num
#             depot1 = nothing
#             lock(lk) do
#                 depot1 = get!(depot_ths, thid) do
#                     Dict{Int, Dict{String, Any}}()
#                 end
#             end
#             for (li, line) in lines_ch
#                 # js = _json_parse_str_I(line)
#                 js = Dict{String, Any}()
#                 depot1[li] = js
#             end
#         end
#     end

#     # find max
#     max_li = 0
#     for (_, depot) in depot_ths
#         for (li, _) in depot
#             max_li = max(max_li, li)
#         end
#     end

#     # TODO: improve this
#     # - preallocate
#     depot_vec = Vector{Dict{String,Any}}(undef, max_li)
#     for li0 in 1:max_li
#         for (_, depot) in depot_ths
#             haskey(depot, li0) || continue
#             depot_vec[li0] = depot[li0]
#         end
#     end

#     return depot_vec
# end

# # ---..- . - .-... . -- -- .. . .- -..
# # #NOTE
# # - You can have hashing in more than one way
# # - a multi factor validation
# # - For instance
# #   - filehash, metalhash, sethash (onsorted)
# # - You can select any combination of validations
# # - #VALIDATORS -> BlobType
# # - They ALL use the same file
# #   - and do not change its content
# # - LiteBlob (by default) validates only with
# #   - filehash (compared with filename (contains))

# # #IDEA
# # - DNA as a hashed-addressed data structure
# #   - #DNAasDataStruct

# # #Validators
# # - Pronblem: Do all validators read the file?
# # - I need to define an interface 
# #   - 1. Just a callback system around eachline
# # - Maybe we do not need/force an universal 
# #   - fileread callback as only "legal" entry point
# #   - but we should be effitient

# # MultiThreading/Processing
# # - In seach, it is "easy" to see use case for parallelization
# # - But maybe we should have an interface
# #   - that run (concurrently) independent readonly (to blob file) routines
# #   - It should be optional so users define a threadshol 
# #   - Because for small routines it might be better just serial
# #   - Also in therms of design
# #   - thinking non-trivialy concurrently is hasrder than serial

# # #NOTE
# # - LiteBlobs must be like git in terms of feature richness and 
# # - sophystication/complexity.
# # - this is an upper bound.

# # ---..- . - .-... . -- -- .. . .- -..
# # Returns the blob object
# # - read the whole file
# function blob_from_file(rt::RootBlob, name::String)
#     name = basename(name)
#     path = joinpath(rt.path, name)
    
#     # Make optional (?)
#     filehash = sha256_file(path)
#     depot0 = _read_blob_depot(path)
    
#     # #TODO/TAI Maybe play with infile metas
#     # - Add a "__blobhash__:except.metas": "sha265-bla..."
#     #   - But just before hashing
#     #   - fill it with an standard
#     #       - "__blobhash__:except.metas": "sha256-XX[...]XX.ljsonl"
#     #   - this will allow you to have an escaped 
#     #       - range of bits
#     #       - the file hash do not have them
#     #       - bacause i should mask them before hashing
#     #       - 

#     # #IDEA
#     # - StaticBlob to MetalBlob or BlobMetal ;)

#     # Meta
#     meta = _blobmetal(depot0, Dict{}())
#     rets = run_callbacks(
#         "LiteBlobs", 
#         "blob_from_file:blob.validators:run", 
#         meta, depot0
#     )
#     # TODO/TAI: Check rets for :break (and similars) statements
#     # isvalid = !any([last(ret) for ret in rets] .== :invalid)
    
#     # filehash
#     isvalid = contains(name, filehash)
    
#     if isvalid
#         # Static
#         return StaticBlob(rt, name, depot0)
#     else
#         # Dynamic
#         return DynamicBlob(rt, name, depot0)
#     end
# end

# # meta = _blobmetal(depot0, Dict{}())
# function _blobmetal(depot::Vector, dflt=nothing)
#     isempty(depot) && return dflt
    
#     head = first(depot)
#     haskey(head, "__blobmetal__") || return dflt
#     return head["__blobmetal__"]
# end

