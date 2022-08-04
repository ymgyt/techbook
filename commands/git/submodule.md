# Submodule

* submoduleのdirectoryをまとめて一つのcommitとして管理している
  * submodule配下のfileを通常のgitのようにひとつひとつ管理しない

* submoduleの状態(commit)はbranchをまたいで共有されるので、checkoutしても追従されるわけではないのでdiffになりがち

## `.gitmodules`

* git projectのsubmoduleを管理するファイル
  * local directoryとremoteの対応関係を管理する

* `git submodule add <url>`で作成される

## Usage

### Submoduleの追加

```shell
# 追加
git submodule add https://github.com/ymgyt/atcoder-lib
# directory名を指定して追加
git submodule add https://github.com/ymgyt/atcoder-lib lib
```

### Submoduleのsubmoduleも取得 

* 初期状態(git clone)ではsubmoduleのdirは空っぽ
  * `git clone --recursive <url>`すれば最初から取得できる

* `git submodule update`は親が認識している時点のcommitにsubmoduleをupdateするという意味
  * submoduleの最新commitになるわけではない

* `git pull`して親の認識を更新したあとsubmoduleの実態を追従させるためにも必要
* submoduleのcommitを変更してcheckoutしても同じことがおきる
  * `git pull --recurse-submodules`で`git pull && git submodule update --recursive`と同じ
  * `git config submodule.recurse true`にしてもよい

```shell
# Submoduleのsubmoduleも取得する
# project rootで実行する
git submodule update --init --recursive
```

### submoduleの最新のcommitを取得

* 親の認識に関係なくsubmoduleの最新を取得する
 
```shell
cd submodule
git pull
```

## Troubleshoot

### `git pull`でsubmoduleに差分がでる

`git pull`によってsubmoduleのcommitが更新されてもsubmodule配下は更新されないので、結果的にgitからみると差分にみえる。  
`git submodule update`をうつ
