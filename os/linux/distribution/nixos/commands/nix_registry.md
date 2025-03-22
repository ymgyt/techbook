# nix registry

* `nixpkgs`が`github:NixOS/nixpkgs/nixpkgs-unstable`に解決されるのはregistryに登録があるから

```sh
# List registry
nix registry list | rg nixpkgs
global flake:nixpkgs github:NixOS/nixpkgs/nixpkgs-unstable
```
