# StorageClass

* adminが提供するstorageのclassを定義する方法
* `metadata.annotations.storageclass.kubernetes.io/is-default-class: true` を指定するとdefault storage classになる
  * storage classが指定されなかった場合に利用される

## Local Storage

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
```

* `provisoner: kubernetes.io/no-provisioner`がlocal storageを表す
* `volumeBindingMode`の意味をわかっていない
