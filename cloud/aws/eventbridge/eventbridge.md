# EventBridge

* CloudWatch Eventsから独立したサービス
  * Default EventBusはCloudWatch Eventsとして機能

* EventSource -> EventBus -> Rule -> Target

## EventBus

EventのPub/Subのインスタンス

* Default
  * AWS systemのeventはここに送られる
    * EC2が止まった
    * 変更できない

* Custom
  * Applicationで利用する場合はこれを作る
  * PutEvents APIで送信

* Partner
  * 他アカウントのCustom EventBusのPub先


## Event

* `detail-type`: `detail`のscheme


## Rule

EventBusで受信したEventを評価して、Targetを決める

### Event Patern

```json
{
  "source": ["aws.ecr"],
  "detial-type": ["ECR Image Action"],
  "detail": {
    "result": ["SUCCESS"],
    "repository-name": ["app"],
    "action-type": ["PUSH"],
    "image-tag": ["latest"]
  }
}
```

を指定すると、fieldごとに一致するか評価して、すべて一致しているかが判定される。

* 前方一致

```json
{ "time": [{"prefix": "2024-10-01"}] }
```

* 例外条件
  * `running` 以外なら

```json
{ "detail": { "state": [{"anything-but": "running"}] }}
```

### Schedule

cron式/rate式で定義すると定期的にeventを発火できる


## Target

* 1 ruleに5のtaregtまで指定できる

### Targetの指定先

* Lambda
* EC2
* Kinesis
* Cloudwatch Logs log group
* ECS Task
* SNS
* SQS
* CodePipeline
* CodeBuild
* 別AWS accountのevent bus

## Access制御

* EventBusへの制御
  * 他のaccountやOrganization同一組織から許可

* Targetへの制御
  * Lambda, SNS, SQS, CloudWatch Logs
    * Resoucre policyでresource側で制御
    * LambdaはLambda policy
    * SNSはtopic policy
    * SQSはqueue policy
    * CloudWatch LogsはdefaultでEventBridgeを許可
  * それ以外はRuleにIAM Roleを割り当ててPolicyを付与する


## Pricing

* 受信したeventに基づいて料金が発生
  * AWSのeventは無料
  * customeは100万eventで1.00USD
