# AWS Organization

## 登場人物

* AWS Accountはmanagementかmember accountに分類される
* Management accountは1 accountのみ

### Management account

* すべてのaccountの支払いを担当する

### Organization Unit(OU)

* 設定の適用範囲
* 複数のmember account or OUをもつ
* Top levelにRoot OUがいる
  * management accountはRoot OUの子account
  * Root OUへのpolicy適用はmanagement accountを含む全accountに適用される


## できること

* Account管理
  * member accountとしてaccountを登録すれば、支払い情報の登録なしにaccountを追加できる
  * Organization(Root)間で、accountを移動もできる

* 請求の一元化
  * 請求はmanagement accountだけで行える

* Account間のResource共有
  * AWS Resource Access Manager(RAM)でaccount間で共有できるらしい

## Features

* Consolidated billing
  * 請求をまとめる機能だけ有効
* All features
  * AWS Organizationの全機能を有効

## Service Control Policy(SCP)
