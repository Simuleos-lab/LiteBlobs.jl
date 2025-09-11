let
    using LiteBlobs
    using SimuleosBase
end

## --.- .- . -.- - . . . -.- . - -- - -- . .,.-. -
let
    path = "..."
    rt = RootBlob(path)
    name = "sha256-a55335.jsonl"
    b = blob(rt, name)
    # - run validators
    #   - ex: filename hash \compare full-content-hash
    #   - ex: __blobmeta__.hash.X hash \compare X-masked-content-hash
    #       - This one is a way to not relay on the file system 
    #           - for validation
    #       - The validation hash is in the __blobmeta__ node
    # - Read/load the file content

    # Features
    # - Mode multiple disk reads
    #   - simple, interface-wise effitient
    #   - parsers load all data on demand
    #       - Load line by line just occationally
    #           - Load __blobmeta__
    #   - Each validator is independent
    #       - for instance, they read the file independent
    #       - validators can run in parallel
    #   - For creating/validating a blob will be need it
    #       - at least two reads
    #       - at least we catch/index validation results

    # - Mode one disk read
    #   - More complex interface
    #   - a master funtion that read the file line by line
    #   - both parsers and validators hook into it
    #   - file reads are try to reduced.

    # - Mode ram file text
    #   - First load text on ram
    #   - Parsers and Validators work on this ram version
    #   - Parsers and Validators work on this ram version

end

## --.- .- . -.- - . . . -.- . - -- - -- . .,.-. -
# MARK: test blob
let
    dbdir = joinpath(@__DIR__, "k.db")
    max_size_MB = 200
    test_blob(dbdir; 
        max_size_MB, 
        resetsb = true
    )
end

## --.- .- . -.- - . . . -.- . - -- - -- . .,.-. -
# MARK: DEV

## --.- .- . -.- - . . . -.- . - -- - -- . .,.-. -
_donothing(x...) = nothing

## --.- .- . -.- - . . . -.- . - -- - -- . .,.-. -
let
    global path = "/Users/pereiro/.julia/dev/LiteBlobs/dev/k.db/sha256-09b7bbfcef5c84125783fca71a2d6e9a48507cc82cfba61d64e59fe964b7cc50.jsonl"

    @time "\n JSON3.read\n" let
        JSON3.read(path; jsonlines=true)
    end

    # @time "\n each_jsonline\n" let
    #     each_jsonline(_donothing, path)
    # end

    @time "\n dev \n" let
        LiteBlobs._each_jsonline_th(_donothing, path)
    end

end


## --.- .- . -.- - . . . -.- . - -- - -- . .,.-. -
let
    global path = "/Users/pereiro/.julia/dev/LiteBlobs/dev/k.db/sha256-09b7bbfcef5c84125783fca71a2d6e9a48507cc82cfba61d64e59fe964b7cc50.jsonl"

    @time "\n JSON3.read\n" let
        JSON3.read(path; jsonlines=true)
    end

    @time "\n _eachline_bytes_v1 \n" let
        bi = 0
        SimuleosBase._eachline_bytes_v1(path; keep = true) do buff
            bi += length(buff)
        end
        @show bi
    end

    @time "\n _eachline_bytes_v2 \n" let
        bi = 0
        # SimuleosBase._eachline_bytes_v2(_donothing, path; keep = true)
        SimuleosBase.eachline_bytes(_donothing, path; keep = true)
    end

    # li = 0
    # @time "\n each_jsonline\n" each_jsonline(path) do js
    #     li += 1
    # end
    # @show li

    # li = 0
    # @time "\n each_jsonline_th\n" each_jsonline_th(path) do js
    #     li += 1
    # end
    # @show li
    
    return nothing
end


## --.- .- . -.- - . . . -.- . - -- - -- . .,.-. -
# DOING
# - Make a io like interface
# - for instance: 
#   - open(rt, name)
#       - will open the file parse it
#       - but will stop reading and returns an object
#   - This object is an iterable that
#   - returns the respective nodes
#   - this is the reading mechanism
#   - mirror of the Base.eachline mecanism
#   - eachnode

## --.- .- . -.- - . . . -.- . - -- - -- . .,.-. -
function _JSON3_read_callback(depot)
    return function(linebytes::Vector{UInt8})
        js = JSON3.read(linebytes, Dict{String, Any})
        # push!(depot, js)
    end
end

_donothing(x...) = nothing


## --.- .- . -.- - . . . -.- . - -- - -- . .,.-. -
# What I want
# - I want to read the file only once per object creation
# - And parse and hash it effitiently
# - The problem is that if I parse it and then drop the text
# - I need to read again for hashing
#   - Maybe it is ok to read for parsing
#   - And hash on demand
#   - The other way around works too

@time "\n  [[let bloc]]" let
    path = "/Users/pereiro/.julia/dev/SimuleosBase/dev/k.db/sha256-367457cebdbb991d62dd15e93d2443130c243accf2adfde1712f91bf062984c2.jsonl"

    # h = sha256_file(path)
    # contains(path, h)
    # _read_blob_file(path)

    rt = RootBlob(dirname(path))
    name = basename(path)
    blob = blob_from_file(rt, name)
    blob[1]
end

# NOTE/SUGGESTION
# - use G[] as "summary" trigger...
#   - this is very fundamental


## --.- .- . -.- - . . . -.- . - -- - -- . .,.-. -
#NOTE
# You can validate an index/cache with 
# - A hash of all the hashes of the files
# - I think I need to compute them some how

#NOTE
# Blobs life cycles
# - dynblob -> [do.work] -> [commit] -> staticblob -> [query]...


## --.- .- . -.- - . . . -.- . - -- - -- . .,.-. -
let
    path = joinpath(@__DIR__, "lite")
    global RT = RootBlob(path)

    sb = RT[st_blob_name]
    db = RT[dyn_blob_name]

    b1 = dynblob(RT)         # load/create dynamic node
    b1 = stblob(RT)          # load static node, error if missing
    b1 = stblob(RT, nothing) # with dflt
    b1 = blob(RT)            # creates a dynamic node

    dat = b1[3][q"query.data.from.node"]

    nd = b1[3][d"query.subnode.from.node"]

    nd::StaticNode # if b1 was static too
    nd::DynamicNode # if b1 was dynamic too

    global S = LiteBlob(RT) # stage blob
    n = LiteNode(S)
end

## -. .. . .- - - - -- .- .-. - -.. .- .- .- - .-.
let
    path = "/Users/pereiro/.julia/dev/SimuleosBase/dev/k.db/sha256-cf600afd063f8be069a0017107787a5091cf962a9f805476b61d5878b895e966.jsonl"
    _load_jsonl(path) do dat, li
        global _dat = dat
        # return :break
    end
end

## -. .. . .- - - - -- .- .-. - -.. .- .- .- - .-.
# DOING: 
# # Make an engine that can record effitiently a lot of json
# into a collection of jsonls (called pages)
# I want the pages to be content-named (sha265 name)
# So, I need one stage file first
#   - Is a file that will be randomly named.
#   - the creator/writter process is responsable of storing it (commit it)
#       - Commiting is just computing the hash and renaming
#       - So, if the creator do not committed, the file will be staged forever
#       - The creator/writter process is also responsable of managing the size

## -. .. . .- - - - -- .- .-. - -.. .- .- .- - .-.
# The root pair
# "$filename": "$hash256(content)"

# #CONCEPT 
# HeatLines interface
# A callback based mecanism for adding dato to the blob
# The las object is the blob concepts space

# TODO: Play with Concept in the name
#   - A blobnode is a concept space


