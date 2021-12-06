# Minikube


## Usage

```console
# minikube 経由でkubectlを起動する
minikube kubectl -- get pods -A

# dashboardを起動する
minikube dashboard
```

## Install

https://minikube.sigs.k8s.io/docs/start/

```console
# Mac
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube
```
