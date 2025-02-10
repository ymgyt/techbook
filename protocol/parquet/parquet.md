# parquet

## Converted type と Logical type

* どちらも、physical type に対しての解釈(annotation)を提供する仕組み。(byte array を utf-8等)
* Converted type が元々ある機能
  * 迷ったらConverted typeを使えばよい?
* Logical type は新しい仕様
  * 互換性を気にしなくて良い、新規開発ならLogial typeか?
