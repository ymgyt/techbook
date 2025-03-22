# nix flake

## Usage

```sh
# Inputの依存関係を表示
nix flake metadata

# outputsを表示
nix flake show

# Inputをupdate
# --update-input は deprecated
nix flake lock --update-input deploy-rs
nix flake update deploy-rs
```

## check(test)

`nix flake check`
