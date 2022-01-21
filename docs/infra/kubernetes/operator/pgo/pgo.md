# PGO

## 構築手順

* [Tutorial](https://access.crunchydata.com/documentation/postgres-operator/v5/quickstart/)
  * 4系もあるので注意

* exampleをforkしてくる
  * https://github.com/CrunchyData/postgres-operator-examples/fork
  * 以降は`./postgres-operator`がforkしてきたrepositoryを指す

* pgoをinstallする
 
```shell
# install pgo
# postgres-operator namespaceが作成される
kubectl apply -k kustomize/install
```

* clusterの名前を変更する
  * postgres-operator/kustomize/postgres/postgres.yaml
  * `metadata.name`をhippoから変更する

* clusterを作成する

```shell
# create cluster
kubectl apply -k postgres-operator/kustomize/postgres
```
