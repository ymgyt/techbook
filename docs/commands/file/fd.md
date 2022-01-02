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
```

* `fd <pattern> [<search_path>]`
  * 探す対象と探す起点を指定する
