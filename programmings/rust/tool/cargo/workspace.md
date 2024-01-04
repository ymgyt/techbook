# workspace

```toml
[workspace]

members = [
    "xxx",
    "yyy",
]

[workspace.dependencies]
tracing = "1.0"
```

```toml
# member/xxx/Cargo.toml
[dependencies]
tracing = { workspace = true, features = ["hoge"] }

[build-dependencies]
baz.workspace = true
```

* `[workspace.dependencies]`にworkspace共通の依存を宣言できる
  * member側は`workspace = true`を指定する

## Specifying dependencies version

* `xxx = "0.1.2`は`"^0.1.2"`と解釈される
* `^1.2.3`のような指定をcaret requirementsという
    * 一番左の0でない数字をincrementしないかぎりupdateが許可されると解釈する
    * `^1.2.3`の場合は`2.0.0`にならない限りどのversion upもうけいれる


