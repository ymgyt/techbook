# cargo-hack

## 概要

* `cargo` の feature 行列チェックを自動化する補助ツール
* `--all-features` で壊れるプロジェクト(排他featureあり)でも回しやすい

## 仕組み

* Cargo featureは加算的
* `--feature-powerset` で対象featureの部分集合(べき集合)を展開して実行
* `--mutually-exclusive-features` で無効な同時有効化を除外

## 基本

```sh
cargo hack clippy --feature-powerset
cargo hack test --feature-powerset
```

## Options

### `--feature-powerset`
* featureの組み合わせを自動展開

### `--include-features <f1,f2,...>`
* 対象featureを限定

### `--mutually-exclusive-features <a,b>`
* 排他featureを指定
* 同時有効化パターンをスキップ

### `--exclude-all-features`
* `all-features` ケースを除外
* 排他featureがあるときに有効

### `--depth <n>`
* 組み合わせの深さを制限
* 例: `--depth 1` は単一featureのみ

### `--exclude-features <f1,f2,...>`
* 特定featureを検証対象から外す

## 例

```sh
cargo hack clippy \
  --feature-powerset \
  --include-features "foo,bar,baz" \
  --mutually-exclusive-features "foo,bar" \
  --exclude-all-features
```

```sh
cargo hack test \
  --feature-powerset \
  --include-features "foo,bar,baz" \
  --mutually-exclusive-features "foo,bar" \
  --exclude-all-features
```
