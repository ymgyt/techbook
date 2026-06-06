# lldb

* `<noun> <verb> [-options] [argument]` という構文で統一されている


```sh
rust-lldb ./target/debug/myapp
```

## breakpoint

```sh
# helpの表示
help breakpoint set

# breakpointの設定
breakpoint set --file src/main.rs --line 10

# breakpointの一覧
breakpoint --list

# commandの実行
run

# single step(n)
next 

# step in
s
```


## 変数の表示

```sh
frame variable
```

* `-s` 変数のscopeの表示
