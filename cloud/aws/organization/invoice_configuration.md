# Invoice Configuration

* 請求ユニット(Invoice unit)
  * Organization accountの排他的な集合
  * 請求書は請求ユニット単位で発行される

* Invoice Receiver
  * 請求書の受取人となるアカウント
  * 請求書を分割しつつ、配信先はManagement accountのままということも可能

* 請求ユニットに含まれないアカウントはこれまで同様、management accountへの請求に含まれる
* 請求ユニットの変更は月内のいつでも行える
* [API Docs](https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_Operations_AWS_Invoicing.html)
* [Terraform resource](https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/invoicing_invoice_unit) ありそう


* 前提
  * Billing > Tax Settings されている

## 請求ユニットの作成

1. 請求ユニットを作成
1. Invoice Receiverを決める
1. アカウントを請求ユニットに含める
