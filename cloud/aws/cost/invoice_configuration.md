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

## Reference

* [Invoice Configurationを使用してAWS請求書を設定](https://aws.amazon.com/jp/blogs/news/configuring-your-aws-invoices-using-invoice-configuration/)
