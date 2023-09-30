# Flakes

Nix 2.4から導入された  
https://nixos.wiki/wiki/Flakes

* File system tree that contains a `flake.nix` nix file in its root directory

Flakesは以下の機能をNixに提供する

1. `flake.nix`によるschema
  * 依存管理の単位になる
2. [Flake references](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#flake-references)

3. 新しいcli


## Enable flakes

`~/.config/nix/nix.conf`

```
experimental-features = nix-command flakes
```


## NixOS

`configuration.nix` and `nixos-rebuild`

```nix
{ pkgs, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
```

## Classic Nix commandとの対応

* `nix-env`: `nix profile`
* `nix-shell`: `nix develop`, `nix shell`, `nix run`に分割
* `nix-build`: `nix build`
* `nix-collect-garbage`: `nix store gc --debug`

## Inputにprivate git reositoryを利用する

1. `nix.conf`にgithubのaccess tokenを記載する

```
 access-tokens = github.com=ghp_XXX
```

2. inputsに指定する `inputs.mysecrets.url = gihtub:ymgyt/mysecrets/main`
