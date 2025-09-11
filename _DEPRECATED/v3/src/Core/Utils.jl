# ..... -.-. -. - - . . .. . .-....- . -. - .-
# MARK: _liteobject

_liteobject(::AbstractLiteNode, n::Number) = n
_liteobject(::AbstractLiteNode, s::String) = s
_liteobject(::AbstractLiteNode, v::VersionNumber) = v

# Implement for concrete subtypes
# function _liteobject(sn::ConcretNode, s::Dict)
#     ...
# end

# TODO/TAI
# _liteobject(v::Vector) = _check_lenght!(v)

# NOTE
# @kuiry"""
# ... query lang
# """

# MARK: liteobject
# depot1 = liteobject(sn, key)
# TODO: interface with more general indexing
function liteobject(sn::AbstractLiteNode, key::String)
    # get val
    depot0 = _node_depot(sn)
    val = getindex(depot0, key)

    # liteobject
    return _liteobject(sn, val)
end

# ..... -.-. -. - - . . .. . .-....- . -. - .-
## MARK: test blob
function test_blob(dbdir::String; 
        max_size_MB, 
        resetsb = false
    )
    # Its ok to 
    max_lines = 10000
    max_size_B = max_size_MB * 1000000

    resetsb && rm(dbdir; force = true, recursive = true) # reset
    isdir(dbdir) || mkdir(dbdir)

    # Produce data (staging)
    # TODO/TAI stage files on the temp folder
    stage_fn = joinpath(dbdir, string("_stage-", uuid_str(), ".jsonl"))
    open(stage_fn, "w") do io
        B_tot = 0
        for li in 1:max_lines
            data = rand_dict(; max_depth=20, max_keys=20)
            B_tot += json_println(io, data)
            if B_tot < max_size_B 
            else
                @show B_tot
                @show li
                break
            end
        end
    end

    # Commit
    _hash = sha256_file(stage_fn)
    cm_name = joinpath(dbdir, string("sha256-", _hash, ".jsonl"))
    # !isfile(cm_name) && mv(stage_fn, cm_name; force = true)
    mv(stage_fn, cm_name; force = true) # maybe re 
    return cm_name
end