# Cluster API

* Kubernetes Clusterのprovisioning, upgradingを行うための宣言的なAPIとtoolを提供するためのsub project

## Memo

* ClusterをCustomResourceとして表現する
* Infrastructure ProviderとBootstrap ProviderはOperator -> YES
* Cluster API Operatorはなにもの

## Custom Resource

* `Cluster`
* `Machine`
  * Clusterを構成するVMや物理Serverの抽象
* `MachineSet`
  * 複数`Machine`を表現
* `MachineDeployment`

### Cluster

Kubernetes cluster

```yaml
apiVersion: cluster.x-k8s.io/v1alpha2
kind: Cluster
metadata:
  name: my-first-cluster
spec:
  clusterNetwork:
    pods:
      cidrBlocks: ["192.168.0.0/16"] # Pod ネットワークに割り当てられるネットワークレンジ
  infrastructureRef: # Infrastructure Provider 固有のリソースへの参照
  apiVersion: infrastructure.cluster.x-k8s.io/v1alpha2
  kind: AWSCluster
  name: my-first-cluster
---
apiVersion: infrastructure.cluster.x-k8s.io/v1alpha2
kind: AWSCluster
metadata:
name: my-first-cluster
spec:
  region: ap-northeast-1 # クラスタを構築するリージョン
  sshKeyName: cluster-api-aws-default # SSH 接続に使うキーペア名
```

### Machine

VMや物理Serverを表す

```yaml
apiVersion: cluster.x-k8s.io/v1alpha2
kind: Machine
metadata:
  name: my-first-cluster-node-0
  labels:
    cluster.x-k8s.io/cluster-name: my-first-cluster # クラスタ名
spec:
  version: v1.15.3 # Kubernetes のバージョン
  bootstrap: # Bootstrap Provider 固有のリソースへの参照
    configRef:
      apiVersion: bootstrap.cluster.x-k8s.io/v1alpha2
      kind: KubeadmConfig
      name: my-first-cluster-node-0
  infrastructureRef: # Infrastructure Provider 固有のリソースへの参照
    apiVersion: infrastructure.cluster.x-k8s.io/v1alpha2
    kind: AWSMachine
    name: my-first-cluster-node-0
```

### MachineDeployment

MachineDeploymentはDeploymentに対応し、MachineSetがReplicaSetに対応する


## Cluster構築

3種類のClusterがある

* Bootstrap Cluster
  * 初期構築で利用する一時的なcluster
  * localで良い. management clusterを手で作ったら意味ない
* Management Cluster
  * Cluster api componentがinstallされたcluster
  * Workload clusterを構築、管理する
* Workload Cluster
  * Management Clusterによりlifecycleを管理される
  * 実際にapplicationを運用する