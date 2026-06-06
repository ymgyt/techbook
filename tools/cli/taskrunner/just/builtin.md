# Builtin Functions

justfile内で利用できる関数

## path

```just
# justfileのsourceのpathを取得できる
# justfile()もあり、rootで利用する分には違いがない
source_file()

source_directory()
```

* `justfile()`, `justfile_directory()`
  * import, moduleで読み込まれている子側で評価しても、rootの呼び出し元のpathを返す

* `source_file`, `source_directory()`
  * 定義されているjustfileのpathを返す
