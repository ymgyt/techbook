# IAM

作成の流れ

1. `aws_iam_role`の作成

```hcl
resource "aws_iam_role" "foo" {
  name = "role-name"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AssumeRole"
        Action = ["sts:AssumeRole"]
        Effect = "Allow"

        Principal = {
          Service = "<service>.amazonaws.com"
        }
      }
    ]
  })
}
```

2. `aws_iam_policy`の作成

```hcl
resource "aws_iam_policy" "policy" {
  name = "policy-name"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cloudwatch:Get*",
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
```

3. attachment
  * `aws_iam_role_policy_attachments_exclusive`を利用すると定義されていないpolicyがはずされる
  * `aws_iam_role_policy_attachment` もある

```hcl
resource "aws_iam_role_policy_attachments_exclusive" "chatbot" {
  role_name = aws_iam_role.foo.name
  policy_arns = [
    aws_iam_policy.policy.arn
  ]
}
```

* `jsonencode`はそのままjsonになるので、Policyのjsonをrespectする
* `data.aws_iam_policy_document`のほうはtfの変換がはいるので注意

## data で policy documentを定義

```hcl
# Assume policy for eks cluster
data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    sid     = "EKSClusterAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "eks_cluster" {
  name               = local.cluster_name
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
}

# Attach managed EKS Policy to eks role
resource "aws_iam_role_policy_attachment" "eks_cluster" {
  for_each = toset(["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"])

  policy_arn = each.value
  role       = aws_iam_role.eks_cluster.name
}
```

* dataでpolicy(statement)を定義する
* `aws_iam_role_policy_attachment`で紐付ける

