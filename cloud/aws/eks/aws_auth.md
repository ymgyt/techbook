# aws-auth

* `kube-system` namespaceに`aws-auth`というConfigMapが作成される。  
* aws-authがIAM Principalとkubernetesの権限の対応を管理する

## 設定例

```yaml

apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: arn:aws:iam::11111111111:role/foo
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: arn:aws:iam::123456789123:role/AWSReservedSSO_AdministratorAccess_0123456789abcdefg
      username: foo
      groups:
        - system:masters

```

* SSOのRoleを設定する場合
  * `rolearnから「/aws-reserved/sso.amazonaws.com/`を除外する
  * session名に表示される最後のpathはいれない


## 参考

* [設定例](https://repost.aws/knowledge-center/eks-configure-sso-user)
* [EKS Best Practice](https://aws.github.io/aws-eks-best-practices/security/docs/iam/#create-the-cluster-with-a-dedicated-iam-role)
* https://qiita.com/Ichi0124/items/d1e2424b0ea01967b05d
