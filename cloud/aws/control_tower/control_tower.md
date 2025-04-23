# Control Tower

* 実態としては他サービスを設定するサービス
  * AWS OrganizationのSCP(Service Control Policy)とAWS Configを設定したり

* Control Towerが作成したResourceの変更はSCPで禁止される

## Log集約

* Log 集約用のS3 bucketがLog Archive accountに作成される
* 各accountのAWS Configのdelivery 先にlog archiveを指定する

## Landing Zone

* ScalableでSecureなmulti account環境のこと
  * Control Tower はlanding zoneの実装方法の一つという位置づけ

* 作成するとLog ArchiveとAudit AWS Accountが作成される
  * CloudFormation Stack
* 複数の設定を組み合わせて目指す状態を作り出す機能をLanding zoneといっている
* Versionをもつ

* AWS Config
  * Management accountにConfig Aggregatorが作成される
    * Audit accountにもAggregatorが作成される
      * Auditのaggregatorにmanagement account分は流れてこない
  * ConsoleのConfigは有効化されないので、CLIで確認できる
    * `aws configservice --profile profile describe-configuration-aggregators --region ap-northeast-1`
  * 被管理accountで、Config Delivery Channel


## Guardrail

* Controls とも
* 実装としては、SCPとAWS Configur ruleの組み合わせ
* category
  * Mandatory: 強制的に有効になる
  * Strongly recommended
  * Elective

* behaviour
  * proactive 
    * CloudFormation hooks で実装されている?
  * detective
    * Security HubとControl Towerが管理
      * Security Hubが管理しているものは、CTのcompilance statusにでないらしい
    * Config rulesで実装
  * preventive
    * SCPで実装

## Account Factory

* Organization同様に新規のaccountを作成する
  * AFで作成すると、landing zoneに登録された状態になる
    * CloudTrail, configがsetup

* 裏ではAWS Service Catalogが使われている


## Reference

* [Comprehensive Guide to AWS Control Tower](https://community.aws/content/2gARwlguBhrXZRSkF4dPQXEJAyB/comprehensive-guide-to-aws-control-tower?lang=en)
* [Log Archive アカウントに作成されるリソース](https://qiita.com/tonkatsu_oishi/items/5bb4fea771ec2a5e075b)
* [Audit アカウントに作成されるリソース](https://qiita.com/tonkatsu_oishi/items/82811c94ebdc6fe509f2)
