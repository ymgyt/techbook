# Helm

## Install

```console
# Mac
VERSION=3.7.2
OS=darwin
curl -sSL https://get.helm.sh/helm-v${VERSION}-${OS}-amd64.tar.gz | tar -xz
mv ${OS}-amd64/helm /usr/local/bin/

helm version
```

### Completion

```console
source <(helm completion zsh)
```

## Repository

```console
helm repo add bitnami https://charts.bitnami.com/bitnami
```

## Search Charts

```console
# repositoryから検索
helm search repo bitnami

# helm hubから検索
helm search hub postgres
```


## Release

* Chart + values = Release
* Releaseはsecretとしてkubernetesに保存される

```console
# list
helm list
```

## Helmからmanifestを作る

Helmのchartからkustomizationで利用できるmanifestを生成する手順。 
ここではvaultを例にとる。  
chartをcustomizeする`values.yaml`はあらかじめ作成してある前提。

```sh
helm repo add hashicorp https://helm.releases.hashicorp.com

helm repo update

helm fetch --untar --untardir /tmp/charts hashicorp/vault

# これで/tmp/outにhelmが適用しようとするmanifest filesが生成される 
helm template \
  --output-dir /tmp/out \
  --namespace vault \
  --values ./helm-values.yaml \
  vault /tmp/charts/vault
```