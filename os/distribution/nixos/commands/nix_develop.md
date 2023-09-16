# nix develop

## Memo

`nix develop "github:DeterminatesSystems/zero-to-nix#exaple"`

```sh
type curl
curl is /nix/store/y2905a3wsvbfla9p5g6j0bfyas8q0598-curl-7.86.0-bin/bin/curl 
```

* `/nix/stroe`: nix store prefix
* `y2905a3wsvbfla9p5g6j0bfyas8q0598-`: hash part
* `curl-7.86.0-bin`: package name
* `/bin/curl`: program path


直接コマンドを実行できる

```
nix develop "github:DeterminateSystems/zero-to-nix#example" --command git help
nix develop "github:DeterminateSystems/zero-to-nix#example" --command curl https://example.com

nix develop -c $SHELL
```
