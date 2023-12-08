# Cluster API

* Kubernetes Clusterのprovisioning, upgradingを行うための宣言的なAPIとtoolを提供するためのsub project

## Components

* Core Provider
  * Cluster apiの本体
* Infrastructure Provider
  * workload cluster, vm, networkのprovisioningを行う
  * 各vendorが提供
* Bootstrap Provider
  * clusterの証明書生成
  * control plane, worker nodeの設定
* Control Plane Provider
  * control planeを作る
    * etcd, api-server, scheduler, dns, controller-manager
  * static pod, deployment, managed(eks)

## Memo

* ClusterをCustomResourceとして表現する
* Infrastructure ProviderとBootstrap ProviderはOperator -> YES
* Cluster API Operatorはなにもの

## Custom Resource

* `Cluster`
  * Workload cluster
* `Machine`
  * Clusterを構成するVMや物理Serverの抽象
* `MachineSet`
  * 複数`Machine`を表現
  * ReplicaSetにあたる
* `MachineDeployment`
  * Deploymentにあたる
* `MachineHealthCheck`
  * Machineの異常を定義

### Cluster

```yaml
apiVersion: cluster.x-k8s.io/v1beta1
kind: Cluster
metadata:
  name: clusterapi-workload-1
  namespace: default
spec:
  clusterNetwork:
    pods:
      cidrBlocks:
      - 192.168.0.0/16
  controlPlaneRef:
    apiVersion: controlplane.cluster.x-k8s.io/v1beta2
    kind: AWSManagedControlPlane
    name: clusterapi-workload-1-control-plane
  infrastructureRef:
    apiVersion: infrastructure.cluster.x-k8s.io/v1beta2
    kind: AWSManagedCluster
    name: clusterapi-workload-1

```

* ClusterApiのschema. top levelのCRD
* `controlPlaneRef` provider固有のcontrol planeの設定
* `infrastructureRef` provider固有のinfrastrutureをprovisioningするresource

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