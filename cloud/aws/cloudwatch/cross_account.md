# Cross Account

* CloudWatch Cross Account Observability
  * Observability Access Manager (OAM) を利用する
    * [API Reference](https://docs.aws.amazon.com/OAM/latest/APIReference/Welcome.html)
  * Sink
    * 共有するリソースと共有先のアカウントを定義する
* Cross Account Cross Region CloudWatch Console

* source account と monitoring account を紐づける方法
  * accoutごとの個別登録
  * Organization 配下の自動登録

* Sink
  * Monitoring accountにある設定instance
  * 1 Regionにひとつ
  * Policyをもつ
* Link
  * Source accountにある設定instance
  * Sinkへの接続を表現



## Observability Access Manager(OAM)

* 複数アカウント間で、CW Metrics, Logs, Tracesを監視用アカウントに集約するサービス
