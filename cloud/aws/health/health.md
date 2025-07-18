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

## Troubleshoot

```sh
aws health describe-events

Could not connect to the endpoint URL: "https://health.ap-northeast-1.amazonaws.com/"
```

* `aws health describe-events --region us-east-1`
  * tokyo regionのendpointはないらしい
