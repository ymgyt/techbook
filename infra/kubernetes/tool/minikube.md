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

### hyperkit

* hperkitを利用する場合

```sh
brew install hyperkit
minikube start --vm-driver=hyperkit
```

## Install

https://minikube.sigs.k8s.io/docs/start/

```console
# Mac
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube
```

## Serviceの公開

* minikubeに作成したserviceにlocal(browser)から接続する

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mongo-express-service
spec:
  selector:
    app: mongo-express
  type: LoadBalancer
  ports:
  - protocol: TCP
    port: 8081
    targetPort: 8081
    nodePort: 30000
```

* `type: LoadBalancer`で作成する

```shell
minikube service mongo-express-service

# check
minikube service list
```

* `minikube service <service>`を実行するとbrowserから接続できるようになる
