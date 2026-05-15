# Journal Mode

* sqliteがatomic commit/rollback を実装する方式
* rollback と WAL の2種類に大別される


## Rollback journal

* 書き込み時に元データをjournal fileに保存しておく
* rollback時はjournal fileから復元する
  * 成功時にjournal fileをdeleteするかtruncateするかといった選択肢がある
* [Atomic Commit in SQLite](https://sqlite.org/atomiccommit.html) の説明が詳しい


## WAL

* Rollbackと異なり変更内容をwal fileに保存する
  * COMMITはWALへのレコード書き込みで表現する
* [WAL](https://sqlite.org/wal.html) が詳しい

### Checkpoint

WAL fileをdatabase fileに統合する処理。
