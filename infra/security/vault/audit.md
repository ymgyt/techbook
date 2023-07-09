# Audit

Vaultのaudit log

* 複数の書き込み先(audit device)がある
* どれか一つに書き込みが成功しないとapiのresponseを失敗させる


## File

fileへのaudit logの書き込み

```sh
vault audit enable file file_path=/var/log/vault_audit.log

vault audit enable -path="vault_audit_1" file file_path=/home/user/vault_audit.log

vault audit enable file file_path=stdout
```

* `-path`を指定すると複数audit deviceがある場合に識別できる
  * defaultはtypeなので、`file`になる
* `file_path`で書き込み先fileを指定できる
* `file_path=stdout`とするとstdoutにaudit logを書き込み
  * logと混ざってしまうが、container環境だと便利 


https://developer.hashicorp.com/vault/docs/audit/file