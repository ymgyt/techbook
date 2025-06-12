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


## Delegated Administorator

* AWS Service ごとに management accountに集約された情報の処理を member account に委譲できる機能
  * management account で有効化した aws health organization view を member account から読めるようにする

* 関連操作
  * `aws organizations list-aws-service-access-for-organization`
  * `aws organizations list-delegated-administrators`
    * どのアカウントにdelegateしたかわかる
  * `aws organizations  list-delegated-services-for-account --account-id ${ACCOUNT_ID}`
    * アカウントに何をdelegateしたかわかる

### 権限の委譲

```sh
aws organizations register-delegated-administrator --account-id <MEMBER_ACCOUNT> --service-principal <SERVICE>
```

具体的になにができるようになるから serviceごとに違う


## Reference

* [AWS Organizationの各ポリシーと継承の整理](https://blog.serverworks.co.jp/aws-organizations-policies-and-inheritance#%E7%B5%84%E7%B9%94%E3%83%9D%E3%83%AA%E3%82%B7%E3%83%BC%E3%82%92%E7%90%86%E8%A7%A3%E3%81%99%E3%82%8B)
  * SCP, RCP だけが特殊なpolicyとわかる
