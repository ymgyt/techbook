# Fargate

* AWSのコンテナ実行環境
  * オーケストレーション(EKS, ECS) から選択できる
  * 同じレイヤーのサービスはEC2

* Serverless
  * patch適用が不要

## EC2との違い

* EKSのDaemonsetは使えない
* ECSのDaemon Scheduling 戦略は使えない
* Container Imageのlocal cacheが使えない
  * 都度hostをprovisioningするため

## Network

* awsvpc modeで動作する
  * ECS管理化のENIがtaskにattachされる

## Volume

* Fargate bind mount / エフェメラルストレージ
  * 揮発性
  * Task内のContainer間で共有可能
  * 20GiBまで無料

* EBS
  * Taskごとに1つのEBSをattach可能

* EFS

## Debug

ECS Execを使う  
Systems Manager Session managerのpluginが必要

```sh
aws ecs execute-command \
  --cluster ${cluster_name} \
  --task ${task_id} --container ${container_name} \
  --interactive --command "/bin/sh"
```

## Price

* Compute Savings Plans の対象

## Fargate Spot

* ECSのみ
* Capacity Provider `FARGATE_SPOT` として利用
