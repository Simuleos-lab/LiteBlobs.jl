# TheLiteStandard

## Tier 0

- is a key value dictionary-like object. 
    - key types 
        - `string` 
    - value types 
        - `string` 
        - `number` 
        - short `arrays` 
        - similar `objects` 
- It needs to be representable/encoded as a valid json file.
    - without lost of information.

## LiteBlobsRunTime (?)

- **LiteBlobs.jl** is a **Tier 0** implementation
- It defines interfaces to be use by Julia applications/packages.
- It aims to make the object as flexible and useful as possible.
- for instance, nice querying system