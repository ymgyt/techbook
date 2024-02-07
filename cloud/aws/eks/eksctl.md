# eksctl


## Worker Node数の変更

cluster.yamlの`desiredCapacity`を変更した上で
```shell
eksctl scale nodegroup -f cluster.yaml
```

## Cluster操作

### Clusterの作成

```shell
eksctl crete cluster -f cluster.yaml
```

### Clusterの削除

```shell
eksctl delete cluster -f cluster.yaml
```

## Managed node group

```shell
# AMIの更新
eksctl upgrade nodegroup --name ng-name --cluster mycluster --region ap-northeast-1 --profile me
```
