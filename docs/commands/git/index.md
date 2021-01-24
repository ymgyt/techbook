# Git

## Usecase

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

### Push to remote branch with a different name

```console
git push origin local-name:remote-name
```

### Amend previous commit

```console
# 直前のcommit messageを修正する。
git commit --amend

# 直前のcommitに追加でaddする。
# addしたい変更はstagingされている想定。
git commit --amend --no-edit
```
