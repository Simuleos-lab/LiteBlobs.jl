# Masked Hash Validator
# - all data on blob content
# - expect a __blobmeta__ subnode on the first node
# - any missing key returns invalid
# - The hash is computed from a masked content
# - In the content, the stored hash is changed by a mask
#   - for instance, file content
#   - {"bla": ..., "__blobmeta__": {"masked.hash": "<masked.hash>sha256-masked-a123[...]f52:sha256-masked-a123[...]f52:sha256-masked-a123[...]f52<masked.hash>"}}
#   - hash data is tripled for security
#   - first, before hashing this line (first)
#   - the hash is masked
#   - same lenght
#   - no injection possible
#   - {"bla": ..., "__blobmeta__": {"masked.hash": "<masked.hash>sha256-masked-XXXX[...]XX:sha256-masked-XXXX[...]XX:sha256-masked-XXXX[...]XX<masked.hash>"}}

# - load/parse node 1
# - check "__blobmeta__"
# - mask "masked.hash"
#   - this should happend on ram
#   - any validator should write into the src file
# - compute content hash

function _run_masked_hash_validator_v1(rt::RootBlob, name::String)
    path = joinpath(rt, name)
end
