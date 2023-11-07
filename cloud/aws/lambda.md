# Lambda

## Execution Role

* lambda作成時に指定するIAM Role
* lambda側で`sts::AssumeRole`が実行される
  * 実行時に環境変数`AWS_SECRET_ACCESS_KEY`,`AWS_ACCESS_KEY{,_ID}`,`AWS_SESSION_TOKEN`がexecution roleのものに設定される

## EventSourceMapping

EventSource(Kinesis/DynamoDB) -> λの処理を作成する際に登場するリソース。  
λをどう呼び出すのかを制御できる。

* `Enabled` : λ呼び出すかどうかの制御

* `BisectBatchOnFunctionError` λがエラー返したら呼び出し時のeventの数をすくなくしてリトライしてくれる。(原因が特定のeventの場合、巻沿いがへるのと、debugにやくだつ
* `DestinationConfig` 規定回数失敗したeventの退避先。最悪運用カバーできる。
* `MaximumRecordAgeInSeconds` 24h以上古いのはカットする的なことができる
* `MaximumRetryAttempts` 最大リトライ数。これ設定できるのはかなり大きい。
* `ParallelizationFactor` 1 shard 1λが原則だけど、1 shard nλができる。 shardを並列に処理できる要件なら有効
* `StartingPosition` : streamに残ってるbufferのどこから読むか。これでLATESTできるの知らなかったから、先にdeployして処理しきってから、有効とかにしていた。
    * `StartingPositionTimestamp`
    * serverless/CloudFormationでは使えなかった。対応されるかは微妙。

### 参考
* [CloudFormation Document](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-lambda-eventsourcemapping.html#cfn-lambda-eventsourcemapping-destinationconfig)
* [DynamoDB Stream](https://docs.aws.amazon.com/lambda/latest/dg/with-ddb.html#services-dynamodb-eventsourcemapping)
* [Kinesis](https://docs.aws.amazon.com/lambda/latest/dg/with-kinesis.html#services-kinesis-eventsourcemapping)
* [Serverless DynamoDB/KinesisStream](https://www.serverless.com/framework/docs/providers/aws/events/streams/)
