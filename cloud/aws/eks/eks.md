# EKS

* versionについては[cluster upgrade](./cluster_upgrade.md)を参照
* GA、betaのfeatureはsupportされる
  * alphaはsupportされない

## Architecture

### IAM

EKS ClusterがAWS Resource(managed nodes)を操作するためにIAM Roleが必要。
これは事前に`AmazonEKSClusterPolicy`かそれに代替するpolicyを付与したIAM Roleを作っておく

EKS Node(Worker node)に必要なIMA Policyは以下  
[Amazon EKS node IAM role](https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html)

### VPC


* VPCを指定する必要がある
* 最低2つのsubnetが必要
  * 異なるAZ

* [EKS VPC and subnet requirements](https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html)

### Control plane

* 最低2つのapi server
  * 3つのetcd
  * AZ間に分散

* Control planeはUserのaws accountとは別のVPCにいる
  * したがって、worker nodeからcontrol planeへのアクセスはinternetを経由する(default)
    * この場合、worker nodeがpublic subnetにいる場合はnodeにpublic ipが付与されている必要がある
    * worker nodeがprivate subnetにいる場合はNATが必要
  * Private endpointという機能がありこれを有効にするとinternetを経由せずにworker nodeはcontrol planeと通信できる
    * publicとprivate両方有効もあるし、private onlyもある

[De-mystrifying cluster networking for EKS](https://aws.amazon.com/blogs/containers/de-mystifying-cluster-networking-for-amazon-eks-worker-nodes/)

### Worker nodes

worker nodeの管理方法にも選択肢がある。
混在させることもできる(たぶん)

* AWS Fargate
* Karnenter
* Managed node group
* Self managed nodes

## Authentication

[./api_access_control.md]を参照

## Troubleshooting

### kubectlが通らない

```
error: You must be logged in to the server (the server has asked for the client to provide credentials)  
```

Cloudwatch logs insightにて

logGroup `/aws/eks/<cluster-name>/cluster`

```
fields @logstream, @timestamp, @message
| sort @timestamp desc
| filter @logStream like /authenticator/
| limit 50
```

で認証の成功/失敗のlogがでるので確認する
