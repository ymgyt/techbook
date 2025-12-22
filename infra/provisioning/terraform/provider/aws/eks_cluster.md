# EKS Cluster

## Cluster

```hcl

locals {
  cluster_name         = "management"
  kubernetes_version = "1.28"
  # 事前にvps/subnetが作ってある前提
  public_subnet_ids = [
    for subnet in aws_subnet.public : subnet.id
  ]
}

resource "aws_eks_cluster" "main" {
  name     = local.cluster_name
  # control planeがAWS API呼ぶためのrole
  role_arn = aws_iam_role.eks_cluster.arn
  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
    # EKSが管理するControl planeとの通信用ENIが作られるsubnet
    subnet_ids              = local.public_subnet_ids
  }
  version = local.kubernetes_version

  # https://docs.aws.amazon.com/ja_jp/eks/latest/userguide/control-plane-logs.html
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  #  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster
  ]
}

# Cluster log management
resource "aws_cloudwatch_log_group" "cluster" {
  name              = "/aws/eks/${local.cluster_name}/cluster"
  retention_in_days = 30
}

# Assume policy for eks cluster
data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    sid     = "EKSClusterAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.${local.aws_dns}"]
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

## Worker node

```hcl
data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.handson.version}/amazon-linux-2/recommended/release_version"
}

# Node Group
resource "aws_eks_node_group" "group1" {
  cluster_name  = aws_eks_cluster.handson.name
  node_role_arn = aws_iam_role.eks_node_group.arn
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }
  subnet_ids = slice(module.vpc.private_subnets, 0, 3)
  version    = aws_eks_cluster.handson.version

  # https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html#AmazonEKS-Type-Nodegroup-amiType
  ami_type        = "AL2_x86_64"
  release_version = data.aws_ssm_parameter.eks_ami_release_version.value
  instance_types  = ["t3.medium"]

  depends_on = [
    aws_iam_role_policy_attachment.eks_node_group
  ]

  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }
}

# IAM
data "aws_iam_policy_document" "eks_node_group_assume_role_policy" {
  statement {
    sid     = "EKSNodeGroupAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.${local.aws_dns}"]
    }
  }
}

resource "aws_iam_role" "eks_node_group" {
  name               = "${local.cluster_name}-nodegroup"
  assume_role_policy = data.aws_iam_policy_document.eks_node_group_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_node_group" {
  # https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  ])

  policy_arn = each.value
  role       = aws_iam_role.eks_node_group.name
}
```

## OIDC

EKS ClusterのOIDC IdPとIAM側で信頼関係を結ぶ。　　
このresourceにより、IAM RoleがOIDCのentityへのassumeを許可できるようになる

```hcl
# https://docs.aws.amazon.com/ja_jp/eks/latest/userguide/enable-iam-roles-for-service-accounts.html
resource "aws_iam_openid_connect_provider" "oidc" {
  url             = data.tls_certificate.eks_cluster.url
  # これがaud
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_cluster.certificates[0].sha1_fingerprint]
}

data "tls_certificate" "eks_cluster" {
  url = aws_eks_cluster.handson.identity[0].oidc[0].issuer
}
```

## Fargate profile

```hcl
resource "aws_eks_fargate_profile" "default" {
  cluster_name           = local.cluster_name
  fargate_profile_name   = "default"
  pod_execution_role_arn = aws_iam_role.pod_execution.arn
  subnet_ids             = local.private_subnet_ids

  selector {
    namespace = "target"
  }
}

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

[ids]
*

[main]
leftalt+- = =
