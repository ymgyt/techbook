# Delve

## Install

### mac
```
xcode-select --install

go get github.com/go-delve/delve/cmd/dlv
```

## Usage

### Test

testをdebugする。

```shell
# cd test directory

dlv test ./ -- -test.run 'TestXXX_AAA'

# break pointはfile名で指定できる。
b internal/domain/xxx/yyy.go:123

# third partyはmoduleの絶対pathで指定できる
 b /Users/ymgyt/go/pkg/mod/github.com/yyy/zzz@v0.0.0-20190927101021-3ecffd272576/src.go:123

# break pointまで実行
c

# 移動する
n

# 関数の中にはいる
s

# 関数からでる
so

# 変数を確認する
p srcVariable

# fieldも確認できる
p srcVariable.List[1]

# 関数も呼べる
call functionName("xxx")

# やり直す
restart

# 終了
quit
```
