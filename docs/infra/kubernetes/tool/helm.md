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
