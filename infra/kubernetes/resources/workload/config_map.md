# ConfigMap

https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/config-map-v1/

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: demo
immutable: false
data:
  # property-like keys; each key maps to a simple value
  key1: "3"
  key2: "foo"

  # file-like keys
  config.ini: |
    c1=1
    c2=2
  config.yaml: |
    hello:
      arry: []
```

* `metadata.name`はDNS Subdomain Name
* `spec.data`: UTF8 stringを保持
  * property likeにするかfileの内容を書くかはconsumeの仕方次第

* `spec.binaryData`: binaryをbase64でencodeして記録できる
* `spec.immutable` trueにすると、kube-apiserverがwatchしなくなりメリットがあるらしいが、変更にはdeleteが必要となる


## Podからの参照

ConfigMapの値をfileとしてPodにみせる方法

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: vault-config
data:
  key1: "HELLO"
  etc-config: |
    aaa = bbb
  extraconfig-from-values.hcl: |-
    disable_mlock = true
    ui = true
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: xxx
spec:
  containers:
  - name: foo
    env:
      - name: FROM_CM  # => HELLO
        valueFrom:
          configMapKeyRef:
            name: 
            - name: foo
    volumeMounts:
      - name: config
        mountPath: /vault/config
      - name: config
        mountPath: /etc/vault/etc-config
        subPath: etc-config
  volumes:
    - name: config
      configMap:
        name: vault-config
        key: key1
```

* `env[].valueFrom.configMapKeyRef.name`で参照する

* `spec.volumes.configMap`で参照する
  * `spec.containers.volumeMounts`でmount pathを決定する
  * `/vault/config/extraconfig-from-values.hcl`というfileがPodから見える
    * configの`data.key`がfile名になり、値がfileのcontentになる

* `spec.containers.volumeMounts.subPath`
  * volumeの特定のpathだけをmountする(defaultは"")
    * configMapの場合、keyを狙ってmountできる
 

