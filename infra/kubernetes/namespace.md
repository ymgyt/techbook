# Namespaces

* cluster内のresourceをisolatingするための機能
* namespace内ではresourceのnameはuniqueである必要がある
* cluster-wide objectsには適用されない(e.g. StorageClass, Nodes, PersistentVolumes, etc)

## Namespacedかの判定方法

```shell
# In a namespace
kubectl api-resources --namespaced=true

# Not in a namespace
kubectl api-resources --namespaced=false
```

## Example

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: <namespace>
```
