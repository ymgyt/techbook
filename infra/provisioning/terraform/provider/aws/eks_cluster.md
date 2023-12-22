# EKS Cluster

## VPS

```hcl
data "aws_availability_zones" "available" {
  # exclude local zones
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "clusterapi-handson"
  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  # Required in eks vpc requirements
  enable_dns_hostnames = true
}
```

## Cluster

```hcl
resource "aws_eks_cluster" "handson" {
  name     = local.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
    subnet_ids              = slice(module.vpc.private_subnets, 0, 3)
  }
  version = "1.28"

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

# IAM Role
locals {
  aws_dns = data.aws_partition.current.dns_suffix
}

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

data "aws_partition" "current" {}
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