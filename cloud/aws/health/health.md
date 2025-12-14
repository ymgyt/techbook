# AWS Health

## Health Event

* AWS Health がAWS の各Serviceの代わりに送るnotification

## Organization View

AWS Organization で管理しているaccountのevent をmanagement account ( or delegated account) に集約できる機能

* Organization view を設定しても、個別のaccount の aws healthや対応するeventbridgeは無効化されず、引き続き有効

### Delegated administration

Health event は management accountに流れてくるので、これを処理するリソースもmanagement accountに作る必要がある。  
これを避けるために、management account から health event の集約先を別の member account にdelegate する機能がある

```sh
aws organizations register-delegated-administrator --account-id MEMBER_ACCOUNT_ID --service-principal  health.amazonaws.com
```

## Primary/Backup region

AWS Healthは通知の耐障害性を高めるために、primary/backup regionという概念がある。
すべてのregionは対応するbackup regionをもち、Health通知はprimary/backup両方に送られる。
[根拠となるdoc](https://docs.aws.amazon.com/health/latest/ug/choosing-a-region.html) 

| Primary | Backup |
| --- | --- |
| Standard AWS Partition regions | Oregon(us-west-2) |
| Oregon(us-west-2) | N.Virginia(us-east-1) |

backupかどうかは`event.detail.backupEvent = true` で判定できる

## Troubleshoot

```sh
aws health describe-events

Could not connect to the endpoint URL: "https://health.ap-northeast-1.amazonaws.com/"
```

* `aws health describe-events --region us-east-1`
  * tokyo regionのendpointはないらしい
