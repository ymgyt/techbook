# Platform Engineering

* テクノロジの多様化をうけて開発者の負担が大きくなったことを背景にソフトウェアのデリバリとライフサイクル管理を目的としたセルフサービス側の企業内開発者プラットフォームの構築と運用に関する取り組み

* CNCFによると
  * Platform Capabilitiesを
    * アクセス権限
    * インフラ
  * Platform Interfacesでwrapすることで 
    * template, gui/cli等のツールと
    * document
  * 開発者が開発しやすい環境


## 自分の理解

* Infra, DB, Messaging, IAM, Security, Observability, Deploy Pipelineといった、Capabilitiesに対して、Template, Documentation, CLIというInterfaceを提供する取り組み
* 認知的負荷の低減がkeywordっぽい
  * 他チームへの依頼とかも内包
* セルフサービス=他部署に依頼してない

## References

* [プラットフォームエンジニアリングの推進における罠](プラットフォームエンジニアリングの推進における罠)
* [プラットフォームエンジニアリングって何？〜基本から AWS での実現方法について](https://aws.amazon.com/jp/blogs/news/20240229-platform-engineering-event/)
