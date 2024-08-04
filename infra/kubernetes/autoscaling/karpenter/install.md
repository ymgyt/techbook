# Karpenter Install

## Helm

```nu
let version = "v0.34.1"
let namespace = "kube-system"
let cluster = "karpenter-handson"
let queue = "EksClusterkarpenter-handsonKarpenterInterrutpionQueue"

(helm template karpenter oci://public.ecr.aws/karpenter/karpenter --version $version 
  --namespace $namespace
  --create-namespace  
  --include-crds
  --set $"settings.clusterName=($cluster)" 
  --set $"settings.interruptionQueue=($queue)" 
  --set controller.resources.requests.cpu=1 
  --set controller.resources.requests.memory=1Gi 
  --set controller.resources.limits.cpu=1 
  --set controller.resources.limits.memory=1Gi) 
```

## AWS

### aws-auth

karpenterによって作成されたnodeのkubeletにnodeを登録できる権限を付与

```sh
kubectl get configmaps -n kube-system aws-auth -oyaml
apiVersion: v1
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::11112223333:role/KarpenterNodeRole-foo
      username: system:node:{{EC2PrivateDNSName}}
  mapUsers: |
    []
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system 
```
