# ServiceAccount

* 各namespaceに必ず1つ以上ある。
  * defaultは`default`

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app
automountServiceAccountToken: true
```

* `automountServiceAccountToken`
  * kubeletがservice accountのtokenをpodにmountするかどうか
  * Pod側でも設定できる。両方ある場合はPod側の設定が優先
  * `/var/run/secrets/kubernetes.io/serviceaccount/token`にmountされる

## Podと紐づく仕組み

* 1.24まではservice accountに対応するsecretが自動で作成されていたがその動作は変更された
* KubernetesがPod作成時にservice accountのtoken(jwt)を作成して、特定のvolumeでmountしている
  * `/var/run/secrets/kubernetes.io/serviceaccount`
  * service accountとしてkube apiへのaccessしたかったら明示的にこれを読む必要がある?