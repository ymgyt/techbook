# graphql-client

rustのgraphql_client crateのcodeを生成するtool

## Install

cargo install graphql_client_cli

## Usage

基本的な使い方は、schmeとgraphql queryがある前提でclient用のcodeを生成するtool。  
jsonにencodeすればgraphql requestになる型とresponseからdeserializeできるresponseの型を生成してくれる


### Schemaの取得

Graphqlのendpointからintrospectを利用してschemaを取得してくることもできる 

`graphql-client introspect-schema http://localhost:8000`


### Client codeの生成

schemaとqueryがある前提

```
"graphql-client" \
  generate \
  --schema-path path/to/schema.json \
  --output-directory src/generated \
  --custom-scalars-module "crate::client::scalar" \
  path/to/query.gql
```

* `--custom-slars-module`でcustom scalarを定義するmoduleを指定する

```rust
type MyScalar = crate::client::scalar::MyScalar
```
というcodeが生成されるので結果的に解決される

### 生成されたstructの確認

cargo docsでみるのが一番わかりやすい

```sh
# moduleのvisibilityに応じて、--document-private-itemsをつける
cargo doc --open --document-private-items --package app --no-deps
```
