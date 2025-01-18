# Automerge

renovate における PR の automerge について

* `automerge`: renovate 自体がPRのmergeを行うかの制御
* `platformAutomerge`

## Assignees Reviewers

* automerge が有効な場合、assignee や reviewer は指定されない
  * notification noise を減らすため
* CI が失敗した場合は、assignees and/or reviewer が指定される

## PR reviewを必須にしている場合

* renovateをbypass させる

## CODEOWNER

* reviewが必須になるので、automergeできない?
  * reviewerにはcodeowner が指定されるが、review必須にしていなければ無視される

* renovateが変更するfileのみCODEOWNERから除外することで、CODEOWNERと両立させる方法もあり

```gitignore
src/ @me  
# 後勝ちなので意図的に指定しない
Cargo.* 
```

## Reference

* [Renovateの大量のPRを処理する技術](https://blog.studysapuri.jp/entry/2022/02/18/080000)
