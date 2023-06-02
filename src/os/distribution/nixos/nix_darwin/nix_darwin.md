# nix-darwin

## Setup

1. nixのinstall
  * [determinate system](https://github.com/DeterminateSystems/nix-installer)を利用してinstallした

2. nix-darwin

```sh
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
```

3. `~/.nkpkgs/darwin-configuration.nix`を編集

4. `darwin-rebuild switch`を実行



https://www.youtube.com/watch?v=r0Y7s1sRSUY

