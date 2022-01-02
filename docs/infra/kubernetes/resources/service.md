# Service

* KubernetesはPod群にsingle DNS nameを付与する
* Podは自身のIPアドレスを付与される
* Podが他のPodの機能を利用する際にServiceを挟むことで、decouplingを実現している


## Service 定義

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

* この定義は、`app=MyApp`のlabelをもち、port 9376でlistenしているPod群を抽象化している。
* ServiceにはClusterIPが付与される
* `metadata.name`がDNS名になる

### LoadBalancer

```yaml
apiVersion: v1
kind: Service
metadata:
  namespace: tinypod
spec:
  type: LoadBalaner
  selector:
    app: applabel
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8001
```
