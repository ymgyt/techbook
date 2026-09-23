# gdb

## 起動

```sh
gdb --quiet --args ./target/debug/bin
```

* `--quiet`: simpleになる
* `--args` : 以降を引数とみなす。実行binに引数わたせる


## Breakpoin

```sh
# 行数指定
break src/path/mod.rs:123
```

## Srcの表示

```sh
list 100,150

# 実行中の関数の確認
frame

# 引数の表示
info args

# local variables
info locals
```

## Control


```sh
# programの実行
run
```

## Layout

```sh
# src表示
Ctrl-x + a
# これも同じ
tui enable
tui disable
```
