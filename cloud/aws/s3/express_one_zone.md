# S3 Express One Zone

* 単一のAZ
  * 99.95% の可用性
* AthenaからQueryうてる

* Directory bucket
  * general bucket とは違う

## Append

* PubObject API
  * `write_offset_bytes` に既存のobjectのsizeを指定することでappendを実現する
* 内部的にはまず、`CreateSession` APIでappend のための認証情報を取得する必要がありそうそう
  * SDKは内部的にやってくれていそう?
