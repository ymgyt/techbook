# NodePools

Karpenterが作成するnodeのconstraintを指定する

* taintを設定できる
  * karpenter上で起動したくないPodで利用できる 
  * NodePoolのtaintがPodでtoleratedされていなければそのPodはそのNodePoolを使わない
    * taintがNodePoolとPodの対応の機構になりそう?
* startup taintも設定できる
  * 起動時に一時的に付与されるtaint

* 作成するnodeのzone, instance type, architectureを指定できる
* defaultのnode expirationを指定できる

* karpenterは最低1つのNodePoolがないとなにもしない
* NodePoolにtaintが指定してあり、Podにtoleratedされていない場合はそのNodePoolを利用しない
* NodePoolを相互排他的(mutally exclusive)に作るのが推奨
  * Podが複数のNodePoolにmatchしないようにする
  * 複数のNodePoolにmatchしたらkarpenterはweightを考慮する


## `spec.template.spec.requirements`

```yaml
spec:
  template:
    spec:
      requirements:
        - key: kubernetes.io/arch
          operator: In
          values: ["amd64"]
        - key: kubernetes.io/os
          operator: In
          values: ["linux"]
        - key: karpenter.sh/capacity-type
          operator: In
          values: ["on-demand"]
        - key: karpenter.k8s.aws/instance-category
          operator: In
          values: ["c", "m", "r"]
        - key: karpenter.k8s.aws/instance-generation
          operator: Gt
          values: ["2"]
```

* `karpenter.sh/capacity-type`: EC2の購入optionの指定
  * `spot`
    * EC2 Fleet's Apiを利用
      * instance typeとzoneごとに45秒apiの結果をcacheする 
  * `on-demand`


## `spec.template.spec.taints`

```yaml
spec:
  template:
      taints:
      - key: nvidia.com/gpu
        value: "true"
        effect: NoSchedule
```




## `spec.disruptin`

TODO

## `spec.limit`

* NodePoolが管理するresourceの最大量
* Karpenter supports limits of any resource type reported by your cloudprovider. 

```yaml
spec:
  limits:
    cpu: 1000
    memory: 1000Gi
    nvidia.com/gpu: 2
```

## `spec.weight`



## Topology Spread Constraint

https://karpenter.sh/v0.35/concepts/scheduling/#topology-spread

> The three supported topologyKey values that Karpenter supports are:
  * topology.kubernetes.io/zone
  * kubernetes.io/hostname
  * karpenter.sh/capacity-type

karpenterは上記3つのTSCしか考慮しない

## Saving Plan / Rserved instanceの利用

https://karpenter.sh/v0.35/concepts/scheduling/#savings-plans-and-reserved-instances

NodePoolを2つ定義して、片方のweightを設定しつつ、savings plan分のlimitsを設定することで先にそれを利用してくれる

## Manifest

```yaml
apiVersion: karpenter.sh/v1beta1
kind: NodePool
metadata:
  name: default
spec:
  # Template section that describes how to template out NodeClaim resources that Karpenter will provision
  # Karpenter will consider this template to be the minimum requirements needed to provision a Node using this NodePool
  # It will overlay this NodePool with Pods that need to schedule to further constrain the NodeClaims
  # Karpenter will provision to launch new Nodes for the cluster
  template:
    metadata:
      # Labels are arbitrary key-values that are applied to all nodes
      labels:
        billing-team: my-team

      # Annotations are arbitrary key-values that are applied to all nodes
      annotations:
        example.com/owner: "my-team"
    spec:
      # References the Cloud Provider's NodeClass resource, see your cloud provider specific documentation
      nodeClassRef:
        name: default

      # Provisioned nodes will have these taints
      # Taints may prevent pods from scheduling if they are not tolerated by the pod.
      taints:
        - key: example.com/special-taint
          effect: NoSchedule

      # Provisioned nodes will have these taints, but pods do not need to tolerate these taints to be provisioned by this
      # NodePool. These taints are expected to be temporary and some other entity (e.g. a DaemonSet) is responsible for
      # removing the taint after it has finished initializing the node.
      startupTaints:
        - key: example.com/another-taint
          effect: NoSchedule

      # Requirements that constrain the parameters of provisioned nodes.
      # These requirements are combined with pod.spec.topologySpreadConstraints, pod.spec.affinity.nodeAffinity, pod.spec.affinity.podAffinity, and pod.spec.nodeSelector rules.
      # Operators { In, NotIn, Exists, DoesNotExist, Gt, and Lt } are supported.
      # https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#operators
      requirements:
        - key: "karpenter.k8s.aws/instance-category"
          operator: In
          values: ["c", "m", "r"]
        - key: "karpenter.k8s.aws/instance-cpu"
          operator: In
          values: ["4", "8", "16", "32"]
        - key: "karpenter.k8s.aws/instance-hypervisor"
          operator: In
          values: ["nitro"]
        - key: "karpenter.k8s.aws/instance-generation"
          operator: Gt
          values: ["2"]
        - key: "topology.kubernetes.io/zone"
          operator: In
          values: ["us-west-2a", "us-west-2b"]
        - key: "kubernetes.io/arch"
          operator: In
          values: ["arm64", "amd64"]
        - key: "karpenter.sh/capacity-type"
          operator: In
          values: ["spot", "on-demand"]

      # Karpenter provides the ability to specify a few additional Kubelet args.
      # These are all optional and provide support for additional customization and use cases.
      kubelet:
        clusterDNS: ["10.0.1.100"]
        systemReserved:
          cpu: 100m
          memory: 100Mi
          ephemeral-storage: 1Gi
        kubeReserved:
          cpu: 200m
          memory: 100Mi
          ephemeral-storage: 3Gi
        evictionHard:
          memory.available: 5%
          nodefs.available: 10%
          nodefs.inodesFree: 10%
        evictionSoft:
          memory.available: 500Mi
          nodefs.available: 15%
          nodefs.inodesFree: 15%
        evictionSoftGracePeriod:
          memory.available: 1m
          nodefs.available: 1m30s
          nodefs.inodesFree: 2m
        evictionMaxPodGracePeriod: 60
        imageGCHighThresholdPercent: 85
        imageGCLowThresholdPercent: 80
        cpuCFSQuota: true
        podsPerCore: 2
        maxPods: 20

  # Disruption section which describes the ways in which Karpenter can disrupt and replace Nodes
  # Configuration in this section constrains how aggressive Karpenter can be with performing operations
  # like rolling Nodes due to them hitting their maximum lifetime (expiry) or scaling down nodes to reduce cluster cost
  disruption:
    # Describes which types of Nodes Karpenter should consider for consolidation
    # If using 'WhenUnderutilized', Karpenter will consider all nodes for consolidation and attempt to remove or replace Nodes when it discovers that the Node is underutilized and could be changed to reduce cost
    # If using `WhenEmpty`, Karpenter will only consider nodes for consolidation that contain no workload pods
    consolidationPolicy: WhenUnderutilized | WhenEmpty
    
    # The amount of time Karpenter should wait after discovering a consolidation decision
    # This value can currently only be set when the consolidationPolicy is 'WhenEmpty'
    # You can choose to disable consolidation entirely by setting the string value 'Never' here
    consolidateAfter: 30s
    
    # The amount of time a Node can live on the cluster before being removed
    # Avoiding long-running Nodes helps to reduce security vulnerabilities as well as to reduce the chance of issues that can plague Nodes with long uptimes such as file fragmentation or memory leaks from system processes
    # You can choose to disable expiration entirely by setting the string value 'Never' here
    expireAfter: 720h

    # Budgets control the speed Karpenter can scale down nodes.
    # Karpenter will respect the minimum of the currently active budgets, and will round up
    # when considering percentages. Duration and Schedule must be set together. 
    budgets: 
    - nodes: 10%
    # On Weekdays during business hours, don't do any deprovisioning.
    - schedule: "0 9 * * mon-fri"
      duration: 8h
      nodes: "0"

  # Resource limits constrain the total size of the cluster.
  # Limits prevent Karpenter from creating new instances once the limit is exceeded.
  limits:
    cpu: "1000"
    memory: 1000Gi

  # Priority given to the NodePool when the scheduler considers which NodePool
  # to select. Higher weights indicate higher priority when comparing NodePools.
  # Specifying no weight is equivalent to specifying a weight of 0.
  weight: 10

```
