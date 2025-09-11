# TheLiteStandard
- is a jsonl file which name contains its content's hash
- the json scheme allow only primitive types 
    - primitives
        - scalar
            - same as json
            - lite
        - string
            - same as json
            - lite
        - null 
            - same as json
            - lite
        - date
            - same as json if exist
            - or very universal simple standard
            - lite
        - version
            - same as json if exist
            - or very universal simple standard
            - lite
        - LiteVector
            - a flat vector of lite primitives
            - with max lenght 100
            - non-lite
        - LiteBlob
            - A keypaired json object
                - keys are strings
                - values are primitives
- You can define a programming language with 
 TheLiteStandard compliant .ljsnol
- file name example
    - `sha256-cf600afd063f8be069a0017107787a5091cf962a9f805476b61d5878b895e966.ljsonl`


- **LiteBlobs.jl** is an implementation
    - and more...
    - `liteblob::Vector{LiteNode}`
    - An `stage` system is available to aid recording
        - A `ljsonl` is just a `jsonl` with some extra type validation
        - It is `open`, that is, it is **mutable**
        - Size limits optional
        - So we can append to a temp file
            - this file is randomly (`UUID4`) named/located
                - We can add an extra security step by adding ...
                    - a random folder wall
                    - take a 
                        - UUID (eg. "4ac3743b-b78c-4e6e-a3ae-7eb100b58c13")
                    - Split the prefix "4ac3743b-b78c-4e6e-a3ae"
                        - by "-"
                    - use each of this to create a folder path
                        - dirpath: "../4ac3743bb78c/4e6e/a3ae"
                    - the final file will be
                        - stagefile
                            - "../4ac3743b/b78c/4e6e/a3ae/stage-7eb100b58c13.ljsonl"
                    
                
            - This way the creator is the only one directly knowing the path
            - recorders are independent
    - `commit` is when a file is "close"
        - We "close it" by adding a very string constraint
        - The file is stable/valid/trustworthy if
            - `hash(read(String, filepath)) \\subset filename`
            - is true
        - # RENAMING POINT
            - We need to rename
                - src: "../4ac3743b/b78c/4e6e/a3ae/stage-7eb100b58c13.ljsonl"
                - dest     
                    - "../sha256-cf600afd063f8be0"
                        - "69a0017107787a5091cf962a9f8"
                            - "05476b61d5878b895e966.ljsonl"
            - in julia `mv` is recomended because is **atomic**
            - But collitions and interference will be low by construction
                - For instance
                    - once I have a hash
                    - i can check if the blob exist
                    - and do something accordingly
                        - call a callback
    - # USER DELETE SCOPE
        - WIP
        - in the stage space, anything can happend
        - in the committed blob space
            - Garbage Collector `gc`
                - official public interface for deleting
                - Soft: If you want to delete
                    - cut all conections using the `gc`.
                        - which can be just a `Notice` node
                            - `{"notice.612gjg34": { "sign": "#SOME-KRYPTO-SIGN", "order": "#DELETE-COMMAND" }}`
                    - If a missing liteblob is missing
                        - the user should/can 
                            - garbage collect it. 
    - # LITENODE content-indexed system
        - It can be implemented using registries...
        - Actually...

    # #WAIT #WAIT #WAIT

    - `liteblob::Vector{LiteNode}`
        - This is not convenient if we want to sign each `BlobNode` too
        - we can have `liteblob::OrderedDict{String, LiteNode}`
            - where the key contains the `hash256(blobcontent)`

    - I can support mutiple files with the same hash
        - `sha256-cf60[...]966.meta.ljsonl`
        - `sha256-cf60[...]966.ljsonl`
        - # KEEP STUFF SIMPLE ...
    
    - # KEEP STUFF SIMPLE
        - namespacing can be implemente on top of `LiteBlobs`
        - `staging` is simple enought that is ok for it to be standard
        - But adding context/data outside the file, #NO
        
    - # ZERO DATA/CONTEXT OUTSIDE LITE BLOBs
    
    - # SOLUTION litenode signing
    - We can still use `liteblob::Vector{LiteNode}`
    - We can have the litenode hashes in another staged node 
        - at closing we close the hash registry
        - we include a new litenode in the `cargo` liteblob.
            - describing how to find the signature node

    - # SOLUTION litenode signing
        - `liteblob::Dict{String, LiteNode}` for "closed" liteblobs
            - `String` hashed/signed from LiteNode content
            / This helps with the universal addressing
        - `stageblob::Vector{LiteNode}` for "staged" liteblobs
            - It allows `push!`ing
        - It will "complicate" the commiting process
        - now, a new file need to be created, not only copied
        - Committing should not be a hot common operation
        - That is presicilly why we have staging
        - You append nodes for a while and them commit a blob

    - # VALIDATION close folder
        - we hash a sorted concatenation of all filenames
            - only blob files
                - we need a `isclosedblob_name` 
                - or we ignore the #DotFiles (ex: ".bla")
        - we hash that and 
            - make a blob which has it
                - remember, no data outside blobs
                - #ISSUE this can't be done
                    - #FixPointProblem
            - or, make a dummy
                - ".folderhash-sha256-75a[...]5dd"
    
    - # FULL FOLDER VALIDATION
    - All is revalidated
        - litenodes
            - `hash(content) \\subset blobkey`
        - liteblob
            - `hash(content) \\subset filename`
        - blobfolder
            - `hash(blobfiles) \\subset filename(folderhash)`

    - `LiteNode`
        - the node `struct`
            - the basic lite standard dict

    - `HashedBlob`
        - a "closed" blob `struct`
        - describes a file
        - as read only as possible
            - desable `setindex!`

    - `PainBlob`
        - #TAI or maybe just a `Blob`
        - an "open" blob `struct`
        - describes a file containing just a dict
        - but, it does not nned to be signed.


    - `StagedBlob`
        - an "open" blob `struct`
        - describes a file
        - mutable

    - `RootBlob`
        - it is the folder descriptor
        - it is a #DotFiles
        - it is just an special `PainBlob`
        - This is the `root` object
            - From it you should access anything
                - insidde the folder

    - # Git and LitBlobs
    - All is text based
    - and lite
    - just saying
    - Should git be a first citizen
        - No at LiteBlobs.jl level
            - its responsabilities are
                - deal with the folder
            - a version is just a folder
                - you tell be which files you want to manipulate
    - Names
        - #LiteGit
        - #LiteGitrepo

    - #NOTE
    - It is storytelling
        - That waht research simulation code workflow is
    <<<

- #NOTE
- Implement types of blobs
- `DynamicBlob`
    - random-hash in the name
    - mutable
    - Can be seems as the state of the machine
        - The machine that produces `StaticBlob`s
- `StaticBlob`
    - content-hash in the name
    - readonly
    - can't be deleted
    - a committed blob



- # Simuleos LiteBlob system
- keep all you committed
    - error and dumb tests are also part of science
    - You will actually have a research jornal, finally.
    - git is like that

- # MYJornal
- given most io applications I use (eg. Obsidian, vscode)
- I will makes them interface with TheLiteStandard
- I want one that collect them all in a single place
- A cronological jornal