# ConfigMap

https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/config-map-v1/

## Create

```console


```

## PodへのMount

ConfigMapの値をfileとしてPodにみせる方法

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: vault-config
data:
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
  volumes:
    - name: config
      configMap:
        name: vault-config
  volumeMounts:
    - name: config
      mountPath: /vault/config
```

1. `spec.volumes.configMap`で参照する
2. `spec.volumeMounts`でmount pathを決定する
3. `/vault/config/extraconfig-from-values.hcl`というfileがPodから見える
  * configの`data.key`がfile名になり、値がfileのcontentになる
 

