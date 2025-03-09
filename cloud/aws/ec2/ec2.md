# EC2

## 料金体系

* Ondemand
  * 通常の利用方法
* Reserved instance
  * resourceの条件を指定して1~3年間の利用契約を結ぶ
* Saving plans
  * 利用するresourceにcommitする契約
* Spot instance
  * AWS側の都合で止まるが安い


## IAM

* Instance profile
    * EC2独自の概念
    * IAM Role のコンテナ
      * EC2 Instance -> IAM Profile -> IAM Role という関係
    * IAM Role と同じ名前のProfile が自動で作られる
      * Iacの場合は意識する必要あり
