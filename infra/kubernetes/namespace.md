# Namespaces

* cluster内のresourceをisolatingするための機能
* namespace内ではresourceのnameはuniqueである必要がある
* cluster-wide objectsには適用されない(e.g. StorageClass, Nodes, PersistentVolumes, etc)
* 原則として他のnamespaceのresourceにはアクセスできない
  * DBが別nsにあり、application用にns-aとns-bがある場合、DBにアクセスするためのsecretはns-aとns-b二つに必要になる。
  * serviceは他のnamespaceのものにアクセスできる

## Namespaceのscope

運用次第が原則。として以下の点を考慮することができる。

* Access制限
  * namespace単位でauthorizationを制御できる
* Resource Limit
  * namespace単位でresourceのlimitを指定できる

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
