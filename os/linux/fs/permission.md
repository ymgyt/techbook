# File Permission

## File

| perm | できること            |
|------|-----------------------|
| `r`  | read file content     |
| `w`  | write content to file |
| `x`  | execute file          |

## Directory

| perm | できること        |
|------|-------------------|
| `r`  | 一覧取得          |
| `w`  | entryの作成、削除 |
| `x`  | cdとinodeへの到達 |


* direcotyrにおける`x`
  * `cat dir/file` にはdirの`x`が必要

* sticky bit
  * `chmod +t dir`
  * dirに`w`をもっていてもfileのownerでなければ削除できなくする
  * `/tmp` に設定することで共有して書き込めるが、他人に消されなくできる
