# Sealed Secrets

## 概要

* SealedSecretというCRを使えるようになる
* git repositoryにはSealedSecretのyamlをcommitする
* この値はSealedSecret Controllerしかdecryptできない
* SealedSecret Operatorがsecret resourceを自動で作成してくれるのであとは通常の流れで使える
* localでのsealed secretの作成はkubeseal cliを利用する

## Install

* githubのrelease assetsの`controller.yaml`を適用する
  * localでもhttpごしでもよい

### Controller

```shell
kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.17.1/controller.yaml
```

### Cli

```shell
brew install kubeseal
```

## Secretの作成

* localにsecret fileを作る

```shell
echo -n bar | kubectl create secret generic mysecret --dry-run=client --from-file=foo=/dev/stdin -o json >mysecret.json
```

* repositoryのcommitしてk8sに適用するsealed secretを作成する
  * `--namespace`を指定する

```shell
kubeseal --namespace=xxx <mysecret.json >mysealedsecret.json
```

* 必要に応じてsealed secretのmetadataを編集する
  * `metadata.{name,namespace}`と`spec.template.metadata{name,namespace}`を編集する
  * 両者は一致する必要がある

* sealed secretを適用する

```shell
kubectl create -f mysealedsecret.json
```

* sealed secretがcontroller側でdecryptされ、secretが確認できる

```shell
kubectl get secrets -n xxx
```
