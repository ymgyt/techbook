# Git

## Usecase

### Initial commit

```
$ git init # creates repository
$ git commit --allow-empty -m'Initial empty commit' # creates empty commit`
```

* `--allow-empty` を指定すると空のcommitが作れる

### Cherry-pick

他branchの特定のcommitだけ取り組みたいときに利用する。  
mergeすると全てのcommitを取り込んでしまうで、取り込みたくないcommitがあるときに使い分ける。

```console
# COMMIT_IDには取り込みたいcommitのIDを指定する。
git cherry-pick ${COMMIT_ID}

# commitはしたくない。
git cherry-pick --no-commit ${COMMIT_ID}
```

### Delete remote branch

```console
git push origin --delete ${BRANCH_NAME}

# reomoteの削除をlocalに反映。
# git-trimがオススメ。
git fetch --prune 
```

### Amend previous commit

```console
# 直前のcommit messageを修正する。
git commit --amend

# 直前のcommitに追加でaddする。
# addしたい変更はstagingされている想定。
git commit --amend --no-edit
```

### Handle Conflicts

feature branchをcheckoutしている状態で、masterをmergeしているケース

```console
# featureの内容が反映される
git checkout conflicted_file.rs --ours

# master側が反映される
git checkout conflicted_file.rs --theirs
```

### Checkout Remote Branch

```console
git fetch
git branch -v -a
...
remotes/origin/test

git switch test
```

* `git switch`でremoteからlocal branchを作成してcheckoutできる。

### Reset

```console
# single fileのreset
git checkout HEAD target.go

# workingを維持したまま特定のcommitまでreset
git reset ${COMMIT_ID}

# unstage files
git reset HEAD -- target.go
```

force pull

```shell
# remote(origin)のmasterを強制的にpullする。
git fetch --all
git reset --hard origin/master
```


### 途中からgitignoreに追加

gitで管理しているfileを途中からgitignoreしても反映されない。(引き続きgit管理される) 

```shell
# 明示的に削除する必要がある。--cachedをつけているのでfilesystemからは削除されない。
git rm --cached <file>
```

### forkしたrepoにupstreamの変更を取り入れる

```sh
git remote add upstream https://github.com/ymgyt/upstream-x
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

### PRをcheckout

```sh
git fetch origin pull/<ID>/head:<local-branch-name>
git checkout <local-branch-name>

# update
git pull origin pull/<ID>/head:<local-branch-name>
```

## Ref

* commitを参照するためのindirect way
  * user friendly alias for a commit hash
  * `.git/refs/`配下にある
