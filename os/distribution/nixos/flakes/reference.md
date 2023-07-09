# Flake References

flakeのlocationを指定する仕様

## URL like syntax

### 

| Refernece | Result                                  |
| ---       | ---                                     |
| `nikpkgs` | `github:NixOS/nixpkgs/nikpkgs-unstable` |


* `github:<owner>/<repo>[/<branch>]`
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
