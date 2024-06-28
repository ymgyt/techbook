# Service

* Serviceが提供する機能
  * Pod群(ReplicaSet)にsingle DNS nameを付与する(=stable ip addressの付与)
  * load balancing
  * Podが他のPodの機能を利用する際にServiceを挟むことで、decouplingを実現している
* Podは自身のIPアドレスを付与される
  * Podはephemeralなので利用側にベタ書きできない

* 実装はkube-proxyがになっている

## `spec.type`

* `ClusterIP`
  * defaultだとこれ。cluster内部でのみ有効なIPが割り当てられる
* `NodePort`
  * ClusterIPをnodeのportを通じて公開する
* `LoadBalancer`
  * ClusterIPを作成し、NodePortを設定したうえで、Serviceを公開するための負荷分散コンポーネントをclusterのinfra(AWSのALB等)に作成する

ポイントはそれぞれ独立しているのではなく段階的に公開の程度があがっていくこと

## ClusterIP

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: MyApp
  ports:
    - protocol: TCP
      port: 80
      # targetPort: httpも可能
      # その場合はPod側でportにname指定が必要
      targetPort: 9376
```

* `type`を指定しない場合のdefault
  * `type: ClusterIP`で明示的に指定もできる
* この定義は、`app=MyApp`のlabelをもち、port 9376でlistenしているPod群を抽象化している。
  * `targetPort`はPodのcontainerがlistenしているport
* ServiceにはClusterIPが付与される
* `metadata.name`がDNS名になる
  * `<service-name>.<namespace>.svc.cluster.local`でcluster内からアクセスできる

## LoadBalancer

```yaml
apiVersion: v1
kind: Service
metadata:
  namespace: tinypod
spec:
  type: LoadBalancer
  selector:
    app: applabel
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8001
```

* LoadBalancerはk8s clusterの外の存在
  * worker nodeのnode portにload balancingする
  * Request -> LoadBalancer -> NodePort -> ClusterIp Svc -> Pod

* LoadBalancerを管理する責務はCloudProviderにある
  * たぶん,LoadBalancerを管理するcontroller(operator)が必要

* 1 Serviceに1 LoadBalancerだと多すぎる場合は、Ingressを使う

## NodePort

* Nodeの
  * 30000 - 32767(要doc)

```yaml
spec:
  type: NodePort
  ports:
  - protocol: TCP
    port: 3200       # service自体のport
    targetPort: 3000 # routing先のPodのport
    nodePort: 30008  # nodeにbindする外部に公開するport
```

* worker nodeの`nodePort`へのアクセスがserviceへroutingされる

## Headless

```yaml
spec:
  clusterIP: None
```

## DNS

* serviceのdns名は`<service>.<namespace>.svc.cluster.local`
  * `/etc/resolve.conf`の設定のおかげで、`svc.cluster.local`, `cluster.local`を勝手に付与してくれる
