# Nix command

## shell

指定したpackageが使える状態でshellを起動する。  

```sh
# 最新のgit repositoryを参照している
nix shell github:edolstra/dwarffs --command dwarffs --version

# よりreproducible
nix shell github:edolstra/dwarffs/cd7955af31698c571c30b7a0f78e59fd624d0229 ...
```

## registry

```sh
# nixpkgsをoverrideする
nix registry add nixpkgs ~/my-nixpkgs
```

## flake

### flake init

create `flake.nix`

### flake metadata
```sh
nix flake metadata github:edolstra/dwarffs

Resolved URL:  github:edolstra/dwarffs
Locked URL:    github:edolstra/dwarffs/1f850df9c932acb95da2f31b576a8f6c7c188376
Description:   A filesystem that fetches DWARF debug info from the Internet on demand
Path:          /nix/store/lpnzz0g4w4vm88khs9aiy68mplwhippq-source
Revision:      1f850df9c932acb95da2f31b576a8f6c7c188376
Last modified: 2022-09-07 02:54:07
Inputs:
├───nix: github:NixOS/nix/586fa707fca207dbd12e49800691390249bdcd03
│   ├───lowdown-src: github:kristapsdz/lowdown/d2c2b44ff6c27b936ec27358a2653caaef8f73b8
│   ├───nixpkgs: github:NixOS/nixpkgs/2fa57ed190fd6c7c746319444f34b5917666e5c1
│   └───nixpkgs-regression: github:NixOS/nixpkgs/215d4d0fd80ca5163643b03a33fde804a29cc1e2
└───nixpkgs follows input 'nix/nixpkgs'
```

### flake show


```sh
nix flake show github:edlstra/dwarffs
```

### flake update

`nix flake update`するとlocalの`flack.lock`を最新にしてくれる

## profile

```sh
nix profile instal github:helix-editor/helix/23.05
```

localに何かをinstallする際はこれ

## store

`nix store gc`