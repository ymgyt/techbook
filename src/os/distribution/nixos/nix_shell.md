# Nix shell

* `nix-shell [-p|--package]`でshellを起動できる

## Usage

```sh
nix-shell -p helix git nodejs
```

* `-p | --package`: installするpackageの指定
* `--run`: shellの中で実行するcommand
* `--pure`: 現在のshellの環境変数を無視する。pathもinstallしていないと通らなくなる
* `-I`: packageのsourceを指定(追加)する

## Shebang

```sh
#!/usr/bin/env nix-shell 
#! nix-shell -i bash --pure
#! nix-shell -p bash cacert curl jq python3Packages.xmljson
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/2a601aafdc5605a5133a2ca506a34a3a73377247.tar.gz

curl https://github.com/NixOS/nixpkgs/releases.atom | xml2json | jq .
```

nix-shellのshebangを複数回書くのと1行に収めるの場合の違いがわかっていない。


## Reproducibility

```shell
`nix-shell \
  -p git \
  --run "git --version" \
  --pure \
  -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/2a601aafdc5605a5133a2ca506a34a3a73377247.tar.gz`
```

