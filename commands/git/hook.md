# Git Hooks

* `.git/hooks`以下にscriptがある
　* `.git`配下なのでそのままでは共有(git管理)できない
* hookのentry pointごとにファイルが決まっていてそれが実行される
  * 非0を返すと処理が止まる
  * trigger毎に複数scriptを指定はできない

## Hooks

### pre-commit

* commit message入力前に実行される
* `git commit --no-verify`で回避可能
