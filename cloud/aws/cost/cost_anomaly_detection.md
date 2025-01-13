# Cost Anomaly Detection

* Anomaly は名詞で"異常"
* 単純な閾値監視では、weekly, monthly の変動に弱い

## 異常検出

* Cost Explorerのデータが基準になる
  * 非ブレンド純コスト
    * 適用されるすべての割引が計算された後の請求額
* 検出は1日3回
* 新しく利用するサービスに関しては異常検出まで10日必要

## Monitor

* Cost explorerで検出対象を指定する
* monitor typeがAWS serviceのmonitorはaccountで1つのみ作成可能
  * Cost Anomaly Detectionを有効化すると自動で作成される場合がある(時期による)

* 連結アカウント(Linked)を複数選択した場合は、総支出を監視する
  * Account-Aでスパイクし、Account-Bで同額が減少した場合、検出されない

* Management accountでのLinked AccountではAccount-AのS3がスパイクし、EC2で同額減少した場合、検出されない
  * Member accountの場合は個別のServiceを検出できる


## Subscription

* Daily/Weeklyのsummaryにすると、通知先はemailになる
  * その日/週で発生した複数のコスト異常の要約
* Individual alert/immediateにするとSNS Topicが必要になる

### Threshold

* 予想支出と実際の支出の差分がコストへの影響(Total Impact)
  * この値に対して設定するのが閾値
  * AND ORで組み合わせられる

* 金額基準
  * コストへの影響が指定した金額を超えた場合

* 割合基準
  * (実際の支出 - 予想支出) / 予想支出 * 100
