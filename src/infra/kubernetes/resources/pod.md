# Pod

## ServiceAccount

```yaml
spec:
  serviceAccountName: fleet-server
  automountServiceAccountToken: true
```

* `automountServiceAccountToken`については調査が必要。


## Env

```yaml
spec:
  containers:
  - name: mongodb
    image: mongo
    ports:
    - containerPort: 27017
    env:
    # Downward api
    - name: NODE_NAME
      valueFrom:
        fieldRef:
          fieldPath: spec.nodeName 

    # 先に定義してあるenvは$(VAR_NAME)で参照できる
    - name: OTEL_RESOURCE_ATTRIBUTES
      value: host.name=$(NODE_NAME)

    - name: MONGO_INITDB_ROOT_USERNAME
      valueFrom:
        secretKeyRef:
          name: mongodb-secret
          key: mongo-root-username
    - name: ME_CONFIG_MONGODB_SERVER
      valueFrom:
        configMapKeyRef:
          name: mongodb-configmap
          key: database_url
    envFrom:    
    - configMapRef:    
        name: ceph-bucket    
    - secretRef:    
        name: ceph-bucket    
```

* `env.[].vlaueFrom.fieldRef`でPodの情報を取得できる
  * [Downward api](https://kubernetes.io/docs/concepts/workloads/pods/downward-api/)という機能
* `env.[].valueFrom.secretKeyRef`でsecretを参照できる
* `env.[].valueFrom.configMapKeyRef`でconfigmapを参照できる
* `envFrom.{configMapRef,secretRef}`でconfig/secretの値をすべて環境変数として取り込める
  * 衝突した際の挙動は要調査。
* 先に定義してある環境変数は`$(VAR_NAME)`で参照できる。

## Image Pull Policy

* `imagePullPolicy`が指定されておらず、(tagが`:latest`の場合 or tagが指定されていない場合)、`Always`になる
* `imagepullPolicy`が指定されておらず、tagが指定されている場合、`IfNotPresent`になる


## Affinity

Podをどこに配置するかに関する指定。

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: with-node-affinity
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: topology.kubernetes.io/zone
            operator: In
            values:
            - antarctica-east1
            - antarctica-west1
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 1
        preference:
          matchExpressions:
          - key: another-node-label-key
            operator: In
            values:
            - another-node-label-value
  containers:
  - name: with-node-affinity
    image: registry.k8s.io/pause:2.0
```

* `IgnoredDuringExecution`はpodをscheduleしたあとにlabelが変更されても気にしないという意味
* `requiredDuringSchedulingIgnoredDuringExecution`
  * 条件が満たされないとpodはscheduleされない
  * `nodeSelectorTerms`は配下の`matchExpressions`をORで評価する
  * `matchExressions`は配下の`key`をANDで評価する
* `preferredDuringSchedulingIgnoredDuringExecution`
  * 考慮するが、条件が満たされなくてもscheduleされる
* `matchExpressions.key`
  * `operator`に使えるのは`In`, `NotIn`, `Exists`, `DoesNotExist`, `Gt` and `Lt`



## Volume

```yaml
apiVersion: v1
kind: Pod
metadata: 
  name: my-app
spec:
  volumes:
  - name: logs 
    persistentVolumeClaim:
      claimName: my-pvc
  - name: hostfs
    hostPath:
      path: /
      type: Directory

  containers:
    - image: xxx
      name: xxx
      volumeMounts:
      - mountPath: /var/logs  
        name: logs
      - mountPath: /host-root
        name: hostfs
        mountPropagation: HostToContainer # これ要調査
        readOnly: true
```

1. `spec.volumes`で利用するvolumeのtypeとnameを指定する
2. `spec.containers.volumeMounts`でcontainerがmountするvolumeの名前とpathを指定する
  * `spec.containers.volumeMounts.readOnly`で読み込み専用にできる

## Security Context

```yaml
spec:
  securityContext:
    runAsUser: 0
```

* `spec.securityContext.runAsUser`でuser idを指定できる。0ならrootになる。


## Recipe

### Debug

debug様のpodのmanifest

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-ceph-block
spec:
  containers:
  - image: busybox:latest
    name: busybox
    imagePullPolicy: Never
    command: ["/bin/sh", "-c", "--"]
    args: ["while true; do sleep 60; done;"]
```

* sleepを`while`で回すよりいい方法があるかも。
  * この方法だとpod delete時のレスポンスが遅い?


## Log

* `/var/log/pods` 配下に実体のfileがある
* kubeletがcontainer runtimeにどこにlog fileを出力すべきかを伝えている
