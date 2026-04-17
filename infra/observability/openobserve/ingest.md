# Ingest

## Ingestまでの流れ

1. Service Account作成

  * UI > IAM Tab
  * New service account
  * EmailとDescriptionを入力
  * Tokenがふりだされるのでcopy

2. Authorization Header

  ```sh
  ["<email>", "<token>"] | str join "@" | encode base64

  #  Authorization: Basic <base64>
  ```
