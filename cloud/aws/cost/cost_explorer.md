# Cost Explorer

* 初期状態ではroot user以外はcost explorerにアクセスできない
  * IAM policyが付与してあっても、permission deniedになってわかりづらい
  * root userでconsole > account > IAM user and access to Billing information をactivateする必要がある

## 設定

### データ保持期間

* defaultだと14ヶ月
* 設定を変えると38ヶ月保持できる
  * Cost Explorer console > Cost Management Preferneces > Multi-year data at monthly granularityを有効にすると
  * `ce:UpdatePreferences` 権限が必要
  * 追加料金はかからないので有効化一択と思われる

### Resource level data at daily granularity

* 有効にすると過去14日間、サービスごとにリソース(ARN) 単位でコストがみれるようになる
  * Service(EC2, ECS,...) ごとに有効にする必要がある

## サービス EC2 - Otherの内訳の見方

1. GroupBy > Dimension に UsageType を指定
2. Filter > Service > EC2 - Other を指定

## UsageType

各Serviceごとの課金単位の項目

### EC2

* {Region}-BoxUsage:{InstanceType}: InstanceTypeごとの ondemandの料金(実行時間)

## API

### Cost and Usage

#### Metrics

* UnblendedCost
  * 課金単価で算出されたコスト。default
* BlendedCost
  * 割引を考慮したコスト
* AmortizedCost
  * RI/Savings Planの前払いを月単位で按分(amortize)したコスト
* NetAmortizedCost
  * AmortizedCostからcredit, リファンドを差し引いた最終的な実コスト
* NetUnblendedCost
  * UnblendedCostにcredit, リファンドを反映した実コスト
* UsageQuantity
  * Costではなく最終的にどれくらいつかったか


## References

* [UsageTypeまとめ](https://qiita.com/kaibeam/items/476ab1bdb15662236aa7)
* [Cost Explorerに38ヶ月間のデータを閲覧可能となる設定等のオプションが追加](https://blog.serverworks.co.jp/new-options-including-view-38-months-of-data-added-to-aws-cost-explorer-settings)
