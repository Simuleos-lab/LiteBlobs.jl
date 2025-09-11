function _each_jsonline_ser(f::Function, path::String)
    li = 0
    eachline_bytes(path; keep=true) do linebytes
        li += 1
        js = _json_parse_bytes_I(linebytes)
        ret = f(li, js)
        ret == :break && return :break
        return nothing
    end
end

function _each_jsonline_th(f::Function, path::String)
    task_ch = Channel{Task}(2*nthreads()) do _ch    
        eachline_bytes(path; keep=true) do linebytes
            tk = Threads.@spawn _json_parse_bytes_I(linebytes)
            put!(_ch, tk)
        end
    end

    for tk in task_ch
        js = fetch(tk)
        ret = f(js)
        ret == :break && return
    end
end

function each_jsonline(path::String)
    chT = Tuple{Int, Dict{String, Any}}
    return Channel{chT}(10) do _ch
        _each_jsonline_th(path) do li, js
            put!(_ch, (li, js))
        end
    end
end

function each_jsonline(f::Function, path::String)
    _each_jsonline_ser(f, path)
end