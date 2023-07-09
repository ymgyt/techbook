# Storage optimization

```sh
nix-store --optimize
nix-store --gc
nix-collect-garbage

sudo nix-collect-garbage --delete-older-than 14d
```