# IAM

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


## inlineでdataを参照

```hcl
resource "aws_iam_role" "pod_execution" {
  name = "foo"

  # ...

  inline_policy {
    name   = "cloudwatchlogs"
    policy = data.aws_iam_policy_document.cloudwatch_log.json
  }
}

data "aws_iam_policy_document" "cloudwatch_log" {
  statement {
    sid = "AllowCloudwatchLogsWrite"
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:PutRetentionPolicy",
    ]
    resources = ["*"]
  }
}
```
