let
    using LiteBlobs
    using SimuleosBase
end

## --.- .- . -.- - . . . -.- . - -- - -- . .,.-. -
# create test blob
let
    dbdir = joinpath(@__DIR__, "k.db")
    max_size_MB = 50
    test_blob(dbdir; 
        max_size_MB, 
        resetsb = true
    )
end
