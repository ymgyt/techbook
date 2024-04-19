# git cherry-pick

他branchの特定のcommitだけ取り組みたいときに利用する。  
mergeすると全てのcommitを取り込んでしまうで、取り込みたくないcommitがあるときに使い分ける。

```console
# COMMIT_IDには取り込みたいcommitのIDを指定する。
git cherry-pick ${COMMIT_ID}

# commitはしたくない。
git cherry-pick --no-commit ${COMMIT_ID}
```
