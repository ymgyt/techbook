# cargo-deny

* 設定ファイルは`deny.toml`
  * `cargo deny init`で初期化できる

## Checks

* cargo denyの機能コンポーネント
* `licenses`: ライセンスチェック
* `bans`: crate関連のチェック
* `advisories`: advisroies
* `sources`

```sh
# ライセンスのチェック
cargo deny check licenses
```
