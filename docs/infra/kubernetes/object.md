# Kubernetes Objects

* Kubernetes objects are persistent entities in the Kubernetes system.

* Kubernetes uses these entities to represent the state of your cluster
  * What containerized applications are running
  * The resources available to those applications
  * The policies around how those applications behave(restart, upgrade,fault-tolerance)
  
* record of intent
  * Kubernetesにsystemのあるべき状態を伝える手段。
  
* Kubernetes APIを利用して操作する

## Spec and Status

* objectは`spec`と`status` fieldをもつ
  * specはcreate時に宣言する
  * statusはobjectのcurrent stateを表現し、systemがつねに更新する


## Required Fields

* `apiVersion`
* `kind`
* `metadata`
* `spec`

## Names and IDs

* objectはnamespace/nameをもつ
  * namespaceとkind内で一意である必要がある
* UIDはclusterでunique


## Objectを操作する方法の概要

https://kubernetes.io/docs/concepts/overview/working-with-objects/object-management/
