# Git Hooks

* `.git/hooks`以下にscriptがある
　* `.git`配下なのでそのままでは共有(git管理)できない
* hookのentry pointごとにファイルが決まっていてそれが実行される
  * 非0を返すと処理が止まる
  * trigger毎に複数scriptを指定はできない

## Repositoryで管理する方法

1. `.githooks` dirを作る(名前はなんでもOK, `.git/hooks`ではない)
2. `.githooks/pre-commit` file を作成する
3. `git config core.hooksPath .githooks`を設定する
    * 当該repo限定でhooksのpathが設定される

## Hooks

### pre-commit

* commit message入力前に実行される
* `git commit --no-verify`で回避可能
