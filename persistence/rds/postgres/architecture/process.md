# Postgres Processes

* master process
  * 最初に起動される
* writer
  * 共有bufferを書き出す
* backend process
  * clientの接続ごとにmaster processから作成(fork?)される
