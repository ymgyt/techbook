# App Runner

* Source codeを提供するかContainer Imageを提供するか大きく二つに別れる
  * service source repository
  * service source source image
    * node,python,javaしかサポートされていない?

## Image repository provider

* app runnerがsupportしているImage repositoryは
  * ECR
  * ECR Public

## Deploy

* container(image)に対して行える設定は
  * 起動時の環境変数
  * 起動コマンド(Dockerfile CMD directive)の上書き
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
  
* Manualはconsole(api)で都度都度起動する

### Deploy Image

* deploy対象はtagまで含めて指定する必要がある
  * <registry>/<repository>:tag
* 違うtagをpushしても無視される
  * これを利用して`:dev`と`:prod`tagのように運用すれば開発と本番の出し分けができそう
* tagのprefix指定ができないので、tagにversionをふる運用ができなそう

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

* Elasticache(redis)に接続できるのは検証済み

## Autoscaling

* Cloudformationからまだ作成できない
  * https://github.com/aws/apprunner-roadmap/issues/88
* Consoleから指定することになりそう。

## Logging

* applicationのstd{out,err}はcloudwatchにそのまま出力される
  * error検知等はここからできそう
* application logの他にdeploy/update時に別のlog groupにlogが出力される
* CloudWatch LogGroupは自動生成なのでRetention設定しておかないと Never expireになる
  * https://github.com/aws/apprunner-roadmap/issues/97

## Pricing

* provisioningしたメモリと実際のCPUベースで課金される
* request来なくてもメモリ分は課金されそう

## Custom domain

* Apprunner側でdomainがふりだされる(awsapprunner.comのsub comain)
* Userのdomainを紐づけることができる(app.ymgyt.io)

* Route53 Hosted zone `foo.ymgyt.io`に`apprun.foo.ymgyt.io`をapprunnerに紐づけたいとする
  * Link domainをconsoleで選択する(Route53以外を選択してもOK)
  * CNAME Recordの作成を指示されるので、Hosted zone `foo.ymgyt.io`に作成する
  * `apprun.foo.ymgyt.io`をName, Alias=true, Record Type: A, 該当apprunnerを選択してrecordを作成する
  * しばらくすると検証が完了する

### Custom domainの紐付け

1. CNAME recordを作る
2. DNS target recordを作る


## ハマったところ

* cdkで1stackの中でECR RepositoryとApp Runner Serviceを作ろうとしてエラーになった。
  * 事前にECR Repo + imageが必要と思われる

* Consoleから環境変数を追加しようとしたがUpdateが失敗し続けた
  * 機能としては対応されている
    * https://github.com/aws/apprunner-roadmap/issues/18
  * cdkから追加したらできた

## Memo

* Update failed. For details, see service logsとでるがどこにもdetailが出力されていない
  * https://github.com/aws/apprunner-roadmap/issues/46
