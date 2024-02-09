# Cluster Autoscaler on AWS

* Amazon EC2 Auto Scaling Groupsを利用
  * ASGのMin/Maxをrespect
* `Deployment`で動く(operator..?)


## Auto discovery

制御するASGを動的に探す。  
ASGに付与されているtagを利用する。

* `--node-group-auto-discovery`
  * `--node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/<cluster-name>`
    * この例ではtagのnameだけをみている
  * `--node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled=foo,k8s.io/cluster-autoscaler/<cluster-name>=bar,my-custom-tag=custom-value`
    * これはtagのvalueまで指定する例


## 参考

* [公式FAQ](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md)
