# Garbage collection

nixはcomponentをnix storeが消さないので、明示的にgcする必要がある。  
内部的には、rootを算出して、それぞれのrootから参照されていないcomponentを検出して消す

```sh
nix-store --optimize
nix-store --gc
nix-collect-garbage

sudo nix-collect-garbage --delete-older-than 14d
```

flake版
```sh
nix profile wipi-history
nix store gc
```