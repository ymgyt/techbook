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

* `CHART VERSION` はhelm chartのversion
* `APP VERSION` はmainのapplicationのversion


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


### Karpenterのkustomize化

Public ECRからchartを取得

```sh
helm pull  --version "v0.34.1"  oci://public.ecr.aws/karpenter/karpenter
tar -xzf karpenter-v0.34.1.tgz
mv karpenter karpenter_repo
```

```nu
let cluster = "karpenter-handson"
let queue = "QueueNameFoo"

(helm template karpenter ./karpenter_repo  
  --output-dir /tmp/karpenter  
  --namespace kube-system 
  --create-namespace  
  --set "settings.clusterName=$cluster" 
  --set "settings.interruptionQueue=$queue" 
  --set controller.resources.requests.cpu=1 
  --set controller.resources.requests.memory=1Gi 
  --set controller.resources.limits.cpu=1 
  --set controller.resources.limits.memory=1Gi) 
```
