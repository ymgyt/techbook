# Link

## 動的リンク(Dynamic Link)

1. execve でメモリに実行ファイルをロード
1. kernelがINTREP sectionに書かれているlinkerをメモリにロードする
1. linkerを起動する?
  * 実行fileを渡される
1. linkerは実行ファイルのDYNAMIC sectionを探す
  * TYPE NEEDEDを探す
1. なんらかの方法で共有ライブラリを探す

## 動的libの検索

1. `RPATH`
  * `RUNPATH`もあるらしい
1. 環境変数 `LD_LIBRARY_PATH`
1. `/etc/ld.so.cache`
1. 標準path

### RPATH(Run-time library search PATH)

* 動的リンクされたlib(`.so`)をロードする際の探索PATH
* ELFに記録されている
* `RUNPATH`もある?

## Reference

* [動的リンクの仕組みとreturn_to_dl_resolve攻撃](https://zenn.dev/ri5255/articles/f61dcc5c7ffd9f)

