# App Runner

* Source codeを提供するかContainer Imageを提供するか大きく二つに別れる
  * service source repository
  * service source source image

## Image repository provider

* app runnerがsupportしているImage repositoryは
  * ECR
  * ECR Public

## Deploy

* `8080`にhttp serverがlistenしている前提
  * 上書きできる(imageConfiguration)
* HTTPSはApp Runnerがterminateしてくれる
* File systemはephemeralで提供される
  * requestを跨いでpersistされることは保証されない
  * ただし、存在する場合もあるのでcache的には使える
    * でも必要ならin memory data store使おう

### Deployment guidelines

* stateless
* delete temporary files
  * out-of-storage errorsを避けるためにtemporary fileは削除するようにする

### Deployment methods

* Automatic deployment
  * 新しいImageをECRにpushするとdeployが走る
  * ECR Publicと異なるAWS Accountには対応していない

* Manual deployment

## IAM

* Instance roleを作成して付与する

## VPC

* VPCと接続すると
  * all outbound trafficが接続したVPCにいく
    * ただしinboundは影響を受けない
    * App Runner trafficも影響を受けない
      * pulling image
      * publish logs
      * retrieving secrets

* VPCに接続するには
  * 接続対象VPCのSubnetを1以上指定
    * App RunnerがsubnetからVPCを特定する
  * SecurityGroupを指定できる
    * 指定しないとVPCのdefault sgが利用される


## ハマったところ

* cdkで1stackの中でECR RepositoryとApp Runner Serviceを作ろうとしてエラーになった。
  * 事前にECR Repo + imageが必要と思われる

## Memo

* CloudWatch LogGroupは自動生成なのでRetention設定しておかないと Never expireになる
