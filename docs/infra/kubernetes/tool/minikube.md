# Minikube


## Usage

```console
# minikube 経由でkubectlを起動する
minikube kubectl -- get pods -A

# dashboardを起動する
minikube dashboard

# deleteする
minikube delete

# minikubeのVM?にアクセスする
minikube ssh

# mountを起動時に行う
# portsをあけておかないと外からminikubeにアクセスできない
minikube start --mount-string "/Users/ymgyt/ws/minikubemnt:/data" --mount --ports=32488:32488
```

## Install

https://minikube.sigs.k8s.io/docs/start/

```console
# Mac
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube
```