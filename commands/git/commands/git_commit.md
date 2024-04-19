# git commit

## Initial commit

```
$ git init # creates repository
$ git commit --allow-empty -m'Initial empty commit'
```

* `--allow-empty` を指定すると空のcommitが作れる


## Amend previous commit

```sh
# 直前のcommit messageを修正する。
git commit --amend

# 直前のcommitに追加でaddする。
# addしたい変更はstagingされている想定。
git commit --amend --no-edit
```
