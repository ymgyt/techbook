# EKS Log

* Controll planeのlogは明示的に有効に設定する必要がある
  * 設定はcomponentごとに制御する

* Component
  * `api` kube-apiserver
  * `audit` kubernetesのaudit
  * `authenticator` EKS固有
    * STSの解決結果のlogのっていたりする
  * `controllerManager`
  * `scheduler`

* Cloudwatch log groupは`/aws/eks/<custer-name>/cluster`になる
  * logのretention daysはこの名前に設定する

