 # kubectl exec

```sh
# shell
kubectl exec <pod> --container <container> -n <namespace> --tty --stdin -- /bin/sh

# 特定のcommandを実行
kubectl exec <pod> --container <container> -n <namespace> --tty --stdin -- /path/app command --arg value
```