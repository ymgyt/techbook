# kube-controller-manager

必須の複数のcontrollerを管理する

## 管理されているcontroller

いまわかっている範囲

* TokenController
  * ServiceAccountのtoken(jwt)を作成している
  * 