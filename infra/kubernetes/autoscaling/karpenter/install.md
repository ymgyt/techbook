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
