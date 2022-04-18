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


### Submodule

設定fileは`.gitmodules`

```console
# 既に登録されているsubmoduleをfetchしてくる
# submoduleを利用しているprojectで最初にうつ
git submodule update [-i]

# submoduleの変更を取り込む
git submodule update --remote [--merge]
```

#### submoduleの変更を取り込む

```console
# submoduleで管理しているdirにcd
cd path/to/submodule_dir
git pull origin master
cd ..

# modified: submodule_dir (new commits)
git status
git add path/to/submodule_dir
git commit -m "update submodule"
```

