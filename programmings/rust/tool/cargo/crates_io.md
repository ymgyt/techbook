# crates.io

## owner

```sh
# owner として招待
cargo owner --add github-handle
cargo owner --remove github-handle

# teamも対象にできる
cargo owner --add github:rust-lang:owners
cargo owner --remove github:rust-lang:owners

# owner の確認
cargo owner --list <crate>
```

* team owner
  * publish or yank versions
  * 他のownerのadd/removeはできない
  * `cargo owner --add github:myorg:team-x`

* 追加するteamのmemberにowern自身が含まれている必要がある


### owner としての、person と team の権限の違い

| \-     | 他の owner の追加/削除 | version の publish/yank |
|--------|------------------------|-------------------------|
| person | できる                 | できる                  |
| team   | できない               | できる                  |
