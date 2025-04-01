# typos

* configuration file
  * `typos.toml`, `_typos.toml`, `.typos.toml`
  * `Cargo.toml`
    * `[workspace.metadata.typos]` or `[package.metadata.typos]`

## Usage

```sh
# check typo
typos

# 処理対象のfile一覧を確認する
typos --files

# write file
typos --write-changes
typos -w
```
