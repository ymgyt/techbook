# ECS

## Capacity

ECSのcontainerをどこで実行するか

* EC2 Instance
* Fargate
* On-premises

## Retirement

* Platform
  * kernelとcontainer runtimeのversionの組み合わせで構成されるruntime
  * kernelの修正やsecurity updateで変更される

* AWSは特定のplatform(revision)をretireさせる判断をする
  * そのrevisionで実行中のtaskを中止する
  * 正確な時間は指定できない
    * wait timeを指定して猶予時間をかえることはできる

* Service Task
  * minimumHealthyPercentを考慮して、taskが停止される
    * 100%を指定している場合、新規のTask作成 -> 停止になる
  * `maximumPercent` を 200%にしておかないと停止前に新規のtaskが立ち上がらない

* Standalone Task
  * `RunTask` APIで実行されたTask
  * __停止自体は避けられない__
  * AWSはreplacement taskを実行しない

* ask がメンテナンスで停止されたかどうか知るには
  * `aws ecs describe-tasks --tasks <TASK_ARN>`
  * `stoppedReason` が `ECS is performing maintenance on the underlying infrastructure hosting the task`

### Retirement wait time

* taskがretireするまでの時間を選べる
* `put-account-setting-default`
  * name: `fargateTaskRetirementWaitPeriod`
  * value
    * `0`(即時)
    * `7` calendar days(default)
    * `14` calendar days
* 既にスケジュールされているretirementには影響しない


```sh
# 確認
# --effective-settings が必要
aws ecs list-account-settings --effective-settings --name fargateTaskRetirementWaitPeriod
```

## ARM

* FargateをARM CPUで動かす
  * `runtimePlatform.cpuArchitecture: "ARM64"` を指定する

```json
{
 "family": "arm64-testapp",
 "networkMode": "awsvpc",
 "containerDefinitions": [
    {
        "name": "arm-container",
        "image": "public.ecr.aws/docker/library/busybox:latest",
        "cpu": 100,
        "memory": 100,
        "essential": true,
        "command": [ "echo hello world" ],
        "entryPoint": [ "sh", "-c" ]
    }
 ],
 "requiresCompatibilities": [ "EC2" ],
 "cpu": "256",
 "memory": "512",
 "runtimePlatform": {
        "operatingSystemFamily": "LINUX",
        "cpuArchitecture": "ARM64"
  },
 "executionRoleArn": "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"
}
```
