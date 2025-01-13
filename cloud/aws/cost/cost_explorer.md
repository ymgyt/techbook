# Cost Explorer

* 初期状態ではroot user以外はcost explorerにアクセスできない
  * IAM policyが付与してあっても、permission deniedになってわかりづらい
  * root userでconsole > account > IAM user and access to Billing information をactivateする必要がある

## データ保持期間

* defaultだと14ヶ月
* 設定を変えると38ヶ月保持できる
  * Cost Explorer console > Cost Management Preferneces > Multi-year data at monthly granularityを有効にすると
  * `ce:UpdatePreferences` 権限が必要


## サービス EC2 - Otherの内訳の見方

1. GroupBy > Dimension に UsageType を指定
2. Filter > Service > EC2 - Other を指定

## UsageType

各Serviceごとの課金単位の項目

### EC2

* {Region}-BoxUsage:{InstanceType}: InstanceTypeごとの ondemandの料金(実行時間)

## References

* [UsageTypeまとめ](https://qiita.com/kaibeam/items/476ab1bdb15662236aa7)
