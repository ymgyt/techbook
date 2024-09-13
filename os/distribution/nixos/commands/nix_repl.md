# nix repl

```sh
nix repl github:NixOS/nixpkgs/23.11

nix-repl> legacyPackages.x86_64-linux.hello

# overrideする際のparameterの確認方法
nix-repl> :e legacyPackages.x86_64.kustomize
```
