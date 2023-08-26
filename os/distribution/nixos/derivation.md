# Derivation

## Memo

* Nix Languageからすると単なるattribute set
* `derivation` functionのattribute setに必須のfieldは3つ
  * `name`
  * `system`: system in which the derivation can be built
    * `x86_64-linux`とか
  * `builder`: binary program that builds the derivation

## `builtins`

```
# System
builtins.currentSystem

# Get attribute names
builtins.attrnames <expr>

# Stringify
builtins.toString <expr>
```
