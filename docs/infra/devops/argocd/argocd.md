# argocd

## Install

```shell
# mac
brew install argocd
```

## Private Repositoryへの接続情報の登録

* private github repositoryへargocdがアクセスできるようにする
* GITHUB_TOKENはあらかじめ生成しておく
  * scopeはrepoだけチェック

```shell
argocd repo add https://github.com/ymgyt/${REPOSITORY} --username ${GITHUB_USER} --password ${GITHUB_TOKEN}
```
