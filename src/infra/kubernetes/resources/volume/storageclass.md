# StorageClass

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