# git subtree

* submoduleと違い、利用者(cloneする人)はsubtreeの存在を意識しない
* 共通options
  * `--debug`
  * `--prefix|-P` 操作対象とするsubtree(required)
  

以下
child repo: subtreeに追加される共有したいrepo
parent repo: childを含む親repo

基本的なworkflow

0. childをgit remote addする(optional)
  * 毎回URL指定でもいける
  * `git remote add -f child https://github.com/ymgyt/child.git`
1. subtree addしてchildをparent管理化に置く
2. subtree pushしてchildに変更を反映する
3. subtree pullでchildの変更を反映する


## Childの取り込み

```sh
git subtree add --prefix tools/ https://github.com/ymgyt/child.git main --squash
# remote addした場合
git subtree add --prefix tools/ child main --squash
```

* merge commitが作られる
* `--squash` child側の履歴をまとめる


## Childの変更を取得

```sh
git subtree pull --prefix tools child main --squash
```


## ChildにParentの変更を反映する

```sh
# Childに書き込み権限がある場合
git subtree push --prefix tools child branch
```

* childに書き込み権限がある場合
  * subtree pushできる

* childに書き込み権限がない場合
  * childをforkしたrepoを作って、そっちにpush

## Split

parent側に積まれたchildに関連する変更を切り出す

`--rejoin` するとはやくなるらしい。よくわかってなし。


## References

* [公式doc](https://github.com/git/git/blob/master/contrib/subtree/git-subtree.adoc)

