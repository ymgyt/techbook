# Cloudformation

## Delete Stack

### DeletionPolicy

Stackを削除する際のリソースの挙動を制御できる。

* Delete
* Retain
* Snapshot (サポートされているリソースのみ、EC2 Volume, RDS, Elasticache,...)

#### Retain

Stackは削除するがリソースはそのままにしておきたい場合に指定する。  
CloudWatch LogsやS3 Bucketとか。  
aws console上から設定する場合はUpdate > Edit current template > edit yaml > create stack

```yaml
MyLambdaLogGroup:
    Type: 'AWS::Logs::LogGroup'
    DeletionPolicy: 'Retain'
    Properties:
      LogGroupName: /aws/lambda/mylambdalog
```

## Output

* exportNameはAccount/Regionのscopeでuniqueである必要がある。
  * CFにexportNameを指定して値を取得するapiがあるのでそれの制約と思われる
