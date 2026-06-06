# Remote repository

* bare repository
  * 作業directoryを持たないrepository
  * GitHub側でhostingされているのはこれ
  * `.git`だけをもっているイメージ

## Remoteのclone

`git clone`を実行すると  
remoteの`.git/refs/heads/`のbranchが、cloneの`.git/refs/remotes/`に格納される。。

copyされるrefから到達可能なobjectはすべてcloneされる


## Remote tracking branch

`.git/config`

```
[remote "origin"]
	url = https://github.com/ymgyt/syndicationd.git
	fetch = +refs/heads/*:refs/remotes/origin/*
```

remoteとlocalのbranchは`refspec`で対応関係が定義ｓれる

* `[+]source:destination`がformat
* `+`をつけるとfast-forward checkが行われなくなる
  * いまいちわかってない

* この設定によって、fetchやpushした際にremoteのどのbranchを対象にしているかが決まる
  * git pullはgit fetchするので、fetchの設定が適用される
