# Invoice Configuration

* Organizationに所属するmember accountに別々の請求書を設定できる
  * management accountで設定できる機能

* Invoice Unit(請求ユニット)
  * 請求書の受取人(Invoice Receiver) accountを1つもつ
    * management accountを指定してもよい
  * 請求ユニットに含まれないアカウントはこれまでと同様
  * 請求ユニットの変更は月内のいつでも行える
    * 日割りは設定次第でできるかも
  * Purchase Order(PO,発注書) を紐づけることもできる
  * 請求書は、management account および invoice receiver account のアドレスにも送られる
  * Tax Settings
    * accountに事業法人名,住所、納税登録者情報が設定されている必要がある

* Invoice Receiver
  * 請求書の受取人となるアカウント
  * 請求書を分割しつつ、配信先はManagement accountのままということも可能

## Reference

* [Invoice Configurationを使用してAWS請求書を設定](https://aws.amazon.com/jp/blogs/news/configuring-your-aws-invoices-using-invoice-configuration/)

# Invoice Configuration



* [API Docs](https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_Operations_AWS_Invoicing.html)
* [Terraform resource](https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/invoicing_invoice_unit) ありそう


## 請求ユニットの作成

1. 請求ユニットを作成
1. Invoice Receiverを決める
1. アカウントを請求ユニットに含める


## CLI


```sh
# 一覧
aws invoicing list-invoice-units
```
