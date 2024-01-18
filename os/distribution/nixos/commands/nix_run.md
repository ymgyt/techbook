# nix run

```sh
nix run nixpkgs#hello

# main branchの最新を利用
nix run github:ymgyt/myapp --refresh
```

* installは走らない
* 内部的にcacheされているらしいので、branch指定の場合で最新を利用したい場合は`--refresh`を利用する
* derivationが`bin` directoryをもっていると以下を探してあったら実行してくれる
  * `meta.mainProgram`
  * `pname`
  * `name`

* If no flake output attribute is given, nix run tries the following flake output attributes:
  * `apps.<system>.default`
  * `packages.<system>.default`

* If an attribute name is given, nix run tries the following flake output attributes:
  * `apps.<system>.<name`
  * `packages.<system>.<name`
  * `legacyPackages.<system>.<name`


```sh
nix run
nix run .#
nix run .#default
nix run .#apps.<system>.default
```
  
