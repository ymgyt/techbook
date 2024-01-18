# Flake References

* flakeのlocationを指定する仕様
* `${URL}#${ATTRIBUTE_PATH}`
  * `#`が特別に展開されるshellの場合はquoteする

## URL like syntax

### 

| Refernece | Result                                  |
| ---       | ---                                     |
| `nikpkgs` | `github:NixOS/nixpkgs/nikpkgs-unstable` |


* `github:<owner>/<repo>[/<reference>]`
  * referenceはbranch,tag,revision
* `nixpkgs#cowsay`の`#`後は、flakeのoutputを指定している

[flake-registry.json](https://github.com/NixOS/flake-registry/blob/master/flake-registry.json)に定義されている。

## Attribute set

```nix
{
  type = "github";
  owner = "NixOS";
  repo = "nixpkgs";
}
```
