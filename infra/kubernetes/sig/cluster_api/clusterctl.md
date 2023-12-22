# clusterctl

## init

```sh
clusterctl init \
  --infrastructure aws \
  --target-namespace capi-providers \
  [-v 5]
```

* kubectlが指してるclusterにcluste api関連のcomponentをinstallしてmanagement clusterにする
* optionalな機能の追加は環境変数経由で行う
* `aws:v0.4.1`のようにproviderのversionを指定できる
* `--trget-namespace`を利用するとinstallされるcomponentのnamespaceを指定できる
  * 指定しない場合はdefault(`capi-system`)が利用される
  * 指定すると全てのcomponentに影響する
* cluster api providerはcert-managerに依存している
* `--validate`
  * install後にvalidation処理を実施。defaultはtrue
* `-v` logging verbosity
  * sourceみる限り5でyaml levelを出力していた


## generate 

Workload Clusterの作成

```sh
clusterctl generate cluster cluster-foo \
  --kubernetes-version v1.27.0 \
  --worker-machine-count=3 \
  --flavor eks
  > cluster.yaml

kubectl apply -f cluster.yaml
```

* Workload cluster用のmanifest(yaml)を生成する
* どのproviderを使うかは推測される。
  * awsしかなければawsを使ってくれる
* `--flavor` providerの中でtemplateを使い分ける仕組み
* `--list-variables` 指定すると必要な環境変数を表示

## kubeconfigの取得

```sh
clusterctl get kubeconfig foo
```

* workload clusterのkubeconfigを取得できる

## Clusterの確認

```sh
clusterctl describe cluster foo
```

## Cluster API componentのupgrade

```sh
clusterctl upgrade apply --infrastructure aws:v1.2.3
```

## Componentのrepositoryの表示

```sh
clusterctl config repositories
```