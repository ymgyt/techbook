# Cost Explorer

## データ保持期間

* defaultだと14ヶ月
* 設定を変えると38ヶ月保持できる
  * Cost Explorer console > Cost Management Preferneces > Multi-year data at monthly granularityを有効にすると
  * `ce:UpdatePreferences` 権限が必要


## サービス EC2 - Otherの内訳の見方

1. GroupBy > Dimension に UsageType を指定
2. Filter > Service > EC2 - Other を指定
