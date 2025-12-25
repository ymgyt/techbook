# EKS Auto Mode

* 非Auto ModeでAWS(EKS)が管理するcomponents
  * API Server instances
  * Etcd instances

* Auto ModeでAWSが管理するcomponents
  * API Server instances
  * Etcd instances
  * EBS CSI
  * VPC CNI
  * Managed Karpententer
  * AWS Load Balancer Controller
  * EKS Pod Identity agent

* EC2 Managed Instance
  * 共同管理?

## Cluster IAM Role

EKS Clusterに付与するIAM Role.
もろもろoffloadするので権限付与も必要

trusted policy
```hcl
resource "aws_iam_role" "control_plane" {
  name = "cluster-role-name"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action = [
        "sts:AssumeRole",
        "sts:TagSession",
      ]
    }]
  })
}
```

policies
* `arn:aws:iam::aws:policy/AmazonEKSClusterPolicy`
* `arn:aws:iam::aws:policy/AmazonEKSComputePolicy`
* `arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy`
* `arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy`
* `arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy`

[EKS Auto Mode cluster IAM role](https://docs.aws.amazon.com/eks/latest/userguide/auto-cluster-iam-role.html)

## Node IAM Role

EC2 nodeのagent?がassumeするrole


## Node

* managed node pool(karpenterのやつ?)が作成される

## Storage Class

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: auto-ebs
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
allowedTopologies:
- matchLabelExpressions:
  - key: eks.amazonaws.com/compute-type
    values:
    - auto
provisioner: ebs.csi.eks.amazonaws.com
volumeBindingMode: WaitForFirstConsumer
parameters:
  type: gp3
  csi.storage.k8.io/fstype: "ext4"
  encrypted: "true"
```

## References

* [EKS Auto Mode: Simplifying Kubernetes Management](https://atmosly.com/blog/amazon-eks-auto-mode-simplifying-kubernetes-management)
