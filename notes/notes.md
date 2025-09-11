- # blob interface
- load!
    - overwritte ram version with disks
- write
    - overwritte disk version with ram
- load_ondemand!
    - overwritte ram version with disks
    - but only if ram is empty
- commit
    - turn a DynamicBlob in a StaticBlob
        - hash all nodes
        - hash content
            - but `__blobmeta__/content.sha256`
- getindex
    - query a blob/node content
- setindex!
    - update a blob/node content
- chain missing for the nodes
- vector interface
- lock
- querying interface
- sync
  - disk = ram
  - ex: universal counter

- #NOTE
- what I learned
  - use _getindex(...) -> depot, key
  - this will allow you to make operations
      - and free indexing


- #NOTE
- # CONTENT HASH STORAGE
- Each blob can have a blob
    - The first or the last
- That contains important metadata
- I do not want to put data in the filename
    - It is useful, but data must 
    - ALWAYS BE IN THE CONTENT OF THE FILE
- So, for StaticNodes    
- We can have a hash that is all the content
- Execpt the hash-storing pairs in the metanode
    - the rest of the metanode is also hashed
    - But the hash itself no
    - For the hashing, it will be use the null-hash
        - `sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.ljsonl`
        - If any unsync happend
        - An error is triggered
- This first blob can be a dedicated one
- Or we will just add it on the first blob
    - Even if it contains data
    - Just add a reserve key
    - ```{
        "__blobmeta__": {
            "content-hash": `sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.ljsonl`, 
            "commit-date-utc": "2025-08-31T16:32:46.394",
            "commit-author-sign": "..."
        }
    }```
    - I will check that the only data outside the hash is the line
        - "content-hash": `sha256-XX...XX.ljsonl`
        - I will check for the lenght
        - No data outside content
            - Given that the hash can be computeted
- Similar stuff for the nodes
- ```{
    "__nodemeta__": {
        "commits": [
            {
                "content-hash": `sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.ljsonl`, 
                "commit-date-utc": "2025-08-31T16:32:46.394",
                "commit-author-sign": "__ref:/1/__blobmeta__/commit-author-sign"
            }
        ]
    }
}```
- Only on commit, all those meta field will be added
- If found before, error, or elimination.
    - Or if hash is valid, noop
    - Or we can have an accumulative commit history
    - Have a vector with all commiters
    - Or only the last one
        - Thsi is the best for the begining
- This should not be a problem in DynamicBlobs
    - Althought not forbiden

#DESIGN
- DB folder will containt two types of Blobs
    - Static blobs
        - Are think as closed blobs of data
        - inmutable
        - The content hash is on the blobs name 
            - I migth add a last/first blob that 
                - Is not considered in the content-hash creation
                - This will make the data independent on the name
    - Dynamic Blobs
        - mutable
        - But also has an unique identifier
            - random in this case
        - Also have a HEAD blob #TODO/TAI
            - For metadata


## Note

- `ContextNode{KT, VT, DT}`
    - A supertype of the julia standard `Dict` interface

- On top of `Dict` the node will implement a flexible value resolution system. 
    - Flexible because you can change it or implement a custom one. 
        - Like julia `Vector` indexing interface. 

## Note

- `DefaultDict{String,Any}(Missing)` is a dict that will return Missing upon finding a non existing key.
- This way we can implement a dictionary where you can Chain key queries
- Also, If we create a typed default return `KeyMissingToken` we can overwrite some cool operators as `||` or `&&` so we can write
    - `dict["bla"]["blo"]["blu"] || 123`
        - This will return `123` is any key misses
    - `dict["bla", "blo", "blu"] || 123`
        - This is maybe better becase we can let the basic interface as the julia standard `Dict`
    - This is actualy a SimuleosBase.jl package

- Or alternatively, I should just extend the base Dict interface witha. full querying language.
    - `dict["bla"]`
        - Typical standard interface
    - `dict[r"^bla"]` or `dict["bla:blo:blu"]` for a nested search
    - you can actually change the indexing/quering protocole if you want!
