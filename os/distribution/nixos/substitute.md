# Substitutes

* source/binaryを透過的に扱う仕組み
* /nix/storeのcomponent(store object)を実際にbuildする以外の方法で作る仕組み
  * 実際はpre-builtされたbinaryをdownloadする
* `https://cache.nixos.org`は公式のcache server

* cacheの有効化
  * `substituers`
  * `trusted-public-keys`

* 設定場所
  * `/etc/nix/nix.conf`
  * `flake.nix`
  * 実行時の`--option`
