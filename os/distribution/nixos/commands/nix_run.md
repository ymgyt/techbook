# nix run

```sh
nix run nixpkgs#hello

# main branchの最新を利用
nix run github:ymgyt/myapp --refresh
```

* installは走らない
* 内部的にcacheされているらしいので、branch指定の場合で最新を利用したい場合は`--refresh`を利用する