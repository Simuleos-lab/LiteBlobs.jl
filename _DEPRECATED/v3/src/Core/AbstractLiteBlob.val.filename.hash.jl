# This validator just sha256 the file content
# And check if in the filename the hash is present

function _run_filename_hash_validator_v1(rt::RootBlob, name::String)
    
    path = _blob_path(rt, name)

    content_hash = sha256_file(path; 
        buff_size = 4096 # KiB
    )

    return Dict(
        "path": path,
    )
end