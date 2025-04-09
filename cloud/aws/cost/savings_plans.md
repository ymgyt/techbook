# Savings Plans

* 1年又は3年のコンピューティング処理をコミットすることで割引を得る仕組み
* Plan Types
  * Compute Savings Plans
  * EC2 Instance Savings Plans
  * SageMaker AI Savings Plans
* Commitする額は割引適用後の金額(実際に払う金額をcommitする)
* 追加で購入できる
　* 適用日が異なるので注意
* Reserved Instance と併用できる
* 7日以内の返品はできる
* 適用は購入した日のその時間から
  * 15日に購入したらその月の15日から適用される

## Compute Savings Plans

* 適用範囲
  * EC2 Instance usage
  * EKS/ECS Faragate
    * Spot には適用されない
  * Lambda
  　* 割引率は15%程度と低い
  * Regionの指定は不要(Global)
  * 適用外
    * RDS


* Commit(購入)する額はディスカウント後の利用料
* 購入時に決めること
  * コミット期間(1年or3年)
  * 支払い方法(upfront, partial front, all upfront)
  * 1時間あたりの利用料

* Reserved Instanceとの併用
  * RIが優先される

### 支払い方法

* No Upfront(前払いなし)
  * 毎月のコミット額を支払う
  * 10USD/hour とした場合、10USD * 24時間 * 30日 = 7,200 USDを毎月支払う
* Partial Upfront(一部前払い)
  * 契約期間の金額の半額を最初に支払う
  * 10USD/hour とした場合、10USD * 24時間 * 365日 / 2 = 43,800USDを支払う
* All Upfront(全額前払い)

## 割引共有

* AWS Organization 単位で有効or無効を制御できる
  * OUをスコープにはできない
* まず購入アカウントに適用される
* 未使用の時間単位のコミットメントがある場合、他のアカウントに適用される
  * 計算された削除額が最も大きいアカウントが優先される
  　* つまり共有対象アカウントは指定できない

## Reference

* [AWSマルチアカウント統制下でのSavings Plansを理解する](https://blog.serverworks.co.jp/savings-plans-purchase-strategies-under-multi-account-control)
* [AWS OrganizationsとSavings Plansを活用したコスト削減のベストプラクティス](https://tech.nri-net.com/entry/2021/04/21/094600)
