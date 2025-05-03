# fd

## Install

```shell
cargo install fd-find
```

## Usage

```shell
# directoryに限定
fd -t d models

# 完全一致
fd -g models

# ext検索
fd --extension nix .

# 検索結果にコマンドを適用
fd --extension dot . search_path --exec dot {/.}
```

* `fd <pattern> [<search_path>]`
  * 探す対象と探す起点を指定する

* `--exec`
  * 検索結果のplaceholderにいろいろある
    * `{/.}` basename without extension
