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
  path/to/query.gql
```
