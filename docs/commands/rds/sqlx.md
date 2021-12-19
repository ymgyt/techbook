# Sqlx Cli

## install

```console
cargo install sqlx-cli
```

## Usage

### 接続先の指定

いずれかの方法で接続先を指定できる

* `--database-url`
* `DATABASE_URL` 環境変数で指定
* currentの`.env`に書く

どのような値(format)かはDBのdriverに依存するので、ここには書かない。
