# EKS Fargate

* Managedなcontainer実行基盤
* EKS Clusterにfargate profileを定義できる
* FargateはPodのselectorをもち、これにPodがmatchするとfargate上でpodが起動される
  * cluster管理者はpodごとのresourceをきにしなくてよい(ことになる)
  * selectorにはnamespaceとlabelを指定できる

* Subnet
  * Private subnet(internet gatewayへのrouteをもたない)のみ
  * public ipを割り当てられないから 

## Pod Execution Role

Fargate上のkubeletがEKS Clusterに参加したり、ECRからPull, LogのCloudWatch等でAWS API権限が必要。
なので、fargate service principlaにassumeできるIAM Roleが必要

Policyとしては`arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy`が付与してある必要がある。

```hcl
resource "aws_iam_role" "pod_execution" {
  name = "${local.cluster_name}-pod-execution-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "pod_execution" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.pod_execution.name
}
```
