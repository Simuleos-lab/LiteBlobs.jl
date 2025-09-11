# .- . . .- - - - - - .. . . .. - -... . .. 
# This will be an invalidated interface
# It can be used to make a partial read of a documment
# 

# .- . . .- - - - - - .. . . .. - -... . .. 
import Base.open
function Base.open(rt::RootBlob, name::String)
    # path
    path = _blob_path(rt, name)

    # read meta
    blobmeta = Dict{String, Any}()
    io = open(path, "r") do io
        for line in eachline(io)
            js = _json_parse_str_I(line)
            blobmeta = get(js, "__blobmeta__", blobmeta)
        end
    end

    # 

    
    # return 
end