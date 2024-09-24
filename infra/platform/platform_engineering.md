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
* Platformはproductで開発者はuser
  * user first
    * userのfeedbackをうけとる
    * best practiceの準拠と既存のworkflowのrespectにtrade-offがあったりする
  * workflowの安全化、高速化
    * ガードレール
  * 小さい改善をiterateする
  * collaboration
    * ペアプロして課題を理解したという事例も


## Developer Portal

* interface
* DPを通じて、IDPを操作するという関係

## Internal Developer Platform

* 開発者に抽象化を提示し、CI/CD,Observability,Infraを一貫性のあるdeveloper experienceとして使用可能な状態にまとめあげることがplatform engineerの役割
  * チームの全員にDevOpsプラクティスの深い理解を要求しない
  * 運用プロセスをモデル化して、それを実行するソフトウェアを構築する
* IDPとも
  * コードを本番環境に導入するために現在使用している手法が、それが何であれ、プラットフォーム
    * 人だったり依頼チケットだったりもする
* developerがself serviceで作業をすすめられる
* Golden path, 適切なdefault値、policyが適用された
  * CI/CD
  * IaC
  * GitOps


## DevOpsとの関係

* PEとは、DevOpsのプラクティスをコードにする試み
* Developerに高い専門性を要求せずに、DevOpsを実践できるようにするもの

## 自動化との関係

* まさに自動化のことだが、完全なサービスライフサイクルのために設計
* x軸に自動化の程度、y軸にscopeを設定した場合に
　* small scopeで、fully automated -> over automated
  * large scopeで、manual -> under automated
