# GitHub CLI

## Token(PAT) の設定

* `GH_TOKEN` でPATを指定できる
* `GH_DEBUG=api` で http requesst のdebugを表示できる

## PR

```sh
# PR用branchでcommitしたのち、PRを作成する
gh pr create

# PRのassigneを変更
# @me をassignee として特別に使える
gh pr edit 123 --repo ymgyt/foo --add-assignee ymgyt
```

## Secret
