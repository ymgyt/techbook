# `aws eks`

## `~/.kube/config`の更新

```console
aws eks update-kubeconfig \
  --region <region> \
  --name <kuseter_name> \
  --role-arn <role-arn> \
  --kubeconfig path/to/kubeconfig.yaml
```

* eksに接続できるようにいい感じにconfigを更新してくれる
* role-arnはcdk作成時のmasterRoleのarnを渡す
* --kubeconfigを渡すと既存とmergeされないように分離もできる

