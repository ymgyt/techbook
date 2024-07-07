# Git

* `git help <command>` でhelpを参照できる
  * `git help switch`

## Usecase

### Delete remote branch

```sh
git push origin --delete ${BRANCH_NAME}

# reomoteの削除をlocalに反映。
# git-trimがオススメ。
git fetch --prune 
```

### Amend previous commit

[./git commit](/commands/git/commands/git_commit.md)を参照

### Handle Conflicts

feature branchをcheckoutしている状態で、masterをmergeしているケース

```shell
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

```shell
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
