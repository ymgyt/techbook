# `aws eks`

## `~/.kube/config`の更新

```console
aws eks update-kubeconfig \
  --region <region> \
  --name <kuseter_name> \
  --role-arn <role-arn>
```

* eksに接続できるようにいい感じにconfigを更新してくれる
* role-arnはcdk作成時のmasterRoleのarnを渡す

