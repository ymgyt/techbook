# EKS Pod Identity

IRSAはEKS(EKS Anyware, Redhat OpenShift, EC2 Self host)に限らないが、Pod IdentityはEKS専用


## 比較

| / | IRSA | Pod Identity |
| -- | --- | --- |
| Scope | EKS,Anyware,OpenShift,SelfHost | EKS |
| IAM Role Session Tags support | False | True | 


## Walkthroug

1. IAM Roleのassume policyを以下のように作成

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "pods.eks.amazonaws.com"
      },
      "Action": [
        "sts:AssumeRole",
        "sts:TagSession"
      ],
      "Condition": {
        "StringEquals": {
          "aws:SourceAccount": "my-account-number"
        },
        "ArnEquals": {
          "aws:SourceArn": "arn-of-my-eks-cluster"
        }
      }
    }
  ]
}
```

* `Principal.Service: "pods.eks.amazonaws.com"`を指定する
* IAMのOIDCの設定をせずにIAM RoleをassumeできるService Accountを指定できる


2. IAM RoleとService Accountのassociationを作成する

* `CreatePodIdentityAssociation` APIを利用する

```hcl
resource "aws_eks_pod_identity_association" "foo" {
  cluster_name    = "my-cluster"
  namespace       = "myns"
  service_account = "foo"
  role_arn        = aws_iam_role.foo_role.arn
}
```

3. Pod作成時のAdmission Webhook

mutating admission webhook が以下を注入する

```yaml
env:
  - name: AWS_CONTAINER_AUTHORIZATION_TOKEN_FILE
    value: "/var/run/secrets/pods.eks.amazonaws.com/serviceaccount/eks-pod-identity-token"
  - name: AWS_CONTAINER_CREDENTIALS_FULL_URI
    value: "http://169.254.170.23/v1/credentials"
volumeMounts:
  - mountPath: "/var/run/secrets/pods.eks.amazonaws.com/serviceaccount/"
    name: eks-pod-identity-token
volumes:
  - name: eks-pod-identity-token
    projected:
      sources:
        - serviceAccountToken:
            audience: pods.eks.amazonaws.com
            expirationSeconds: 86400
            path: eks-pod-identity-token  
```

4. SDKによるcredential解決

  1. env の static credential (AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY)
  2. web identity token (AWS_WEB_IDENTITY_TOKEN_FILE がある場合。これが IRSA の口)
  3. shared config file (~/.aws/ の profile)
  4. container credentials (AWS_CONTAINER_CREDENTIALS_FULL_URI がある場合。これが Pod Identity の口。もともと ECS 用の口の再利用)
  5. IMDS (EC2 instance role)

5. Credential 取得

`GET http://169.254.170.23/v1/credentials`
`Authorization: eyJhbGciOiJSUzI1NiIs...`   ← token file の中身をそのまま

response は ECS の credential endpoint と同じ形の JSON です:

```json
  {
    "AccessKeyId": "ASIA...",
    "SecretAccessKey": "...",
    "Token": "...",
    "Expiration": "2026-07-14T12:34:56Z"
  }
```
