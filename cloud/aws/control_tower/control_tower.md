# Control Tower

* 実態としては他サービスを設定するサービス
  * AWS OrganizationのSCP(Service Control Policy)とAWS Configを設定したり

* Control Towerが作成したResourceの変更はSCPで禁止される

## Log集約

* Log 集約用のS3 bucketがLog Archive accountに作成される
* 各accountのAWS Configのdelivery 先にlog archiveを指定する

## Landing Zone

* 作成するとLog ArchiveとAudit AWS Accountが作成される

## Reference

* [Log Archive アカウントに作成されるリソース](https://qiita.com/tonkatsu_oishi/items/5bb4fea771ec2a5e075b)
* [Audit アカウントに作成されるリソース](https://qiita.com/tonkatsu_oishi/items/82811c94ebdc6fe509f2)
