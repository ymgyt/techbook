# git format-patch

## Usage

```sh
# 直近2 commitをpatch化
git format-patch -2

# with cover letterを指定
git format-patch -2 --cover-letter -o /tmp/patch
```

* `-<n>`
  * 直近n commitからpatchを作成する
* `--cover-letter`
  * `0/2`のような最初のpatchを作る
* `-o`
  * 出力先の指定
