# Directive

* `ProtectSystem`
  * `true|false|full|strict`
  * mountをread-onlyにするもの
    * fullにすると`/usr`, `/boot`, `/etc`がread onlyでmountされる

* `RootDirectory`: 指定のdirectoryにchrootされた状態でprocessを実行する。