# Resource Explorer

## Mental Model

* Resource
  * 検索対象となるAWS Resource
* Index
  * Resource の情報を保持するコンテナ
* View
  * 検索interface
  * 対象とfileterを管理

## Resource

Resource Explorer が保持するのはリソースのメタデータのみ:

- ARN
- リソースタイプ (例: `cognito-idp:userpool`, `ec2:instance`, `s3:bucket`)
- サービス名 (例: `cognito-idp`, `ec2`)
- リージョン
- 所有アカウントID
- タグ
- 最終レポート日時


## Index

### Index (データ収集)

リソースのメタデータを収集・保持する。アカウント+リージョンごとに1つ作る。
2種類ある

* Local
  * そのアカウント+リージョン内のリソースを収集する
  * アカウント+リージョンごとに1つ
  * 自動的にそのアカウント+リージョンのリソースを発見・追跡する。
* AGGREGATOR
  * 複数の LOCAL Index のデータを集約する
  * org 全体で1つだけ
  * LOCAL Index からレプリケーション (非同期) でデータを受け取る。

```
Account A / ap-northeast-1 → LOCAL Index (A の ap-northeast-1 のリソース)
Account A / us-east-1      → LOCAL Index (A の us-east-1 のリソース)
Account B / ap-northeast-1 → LOCAL Index (B の ap-northeast-1 のリソース)
         ...
管理アカウント / ap-northeast-1 → AGGREGATOR Index (全 LOCAL の集約先)
```


## View

検索は必ず View を通して行う。View は検索のスコープ (対象範囲) とフィルタを定義する。

* Scope
  * アカウント: そのアカウントのリソースのみ
    * デフォルトで作成される
  * OU
    * 指定した OU 配下のアカウント
  * Organization
    * org 全体の全アカウント


## Organization 設定

* Resource Explorer を org 横断で使うには、Organizations 側の設定が必要:
  1. **Trusted Access**: Resource Explorer サービスが Organizations の情報 (アカウント一覧、OU 構造) にアクセスすることを許可する。これがないと org スコープの View を作れない
  2. **Delegated Administrator** (オプション): Resource Explorer の管理を管理アカウント以外に委任する。今回は使っていない

### なぜ Systems Manager Quick Setup が登場したか

課題: 全メンバーアカウントに LOCAL Index を作る必要がある
AGGREGATOR Index は集約先であり、集約元の LOCAL Index が各アカウントに存在しなければデータは来ない。
つまり org に 19 アカウント x 16 リージョン = 304 箇所に LOCAL Index を作る必要がある。

各アカウントに assume role できない
各メンバーアカウントに個別にログインして `create-index` を実行するのは非現実的 (そもそも全アカウントへの assume role 権限がない)。

解決: CloudFormation StackSets

CloudFormation StackSets は、管理アカウントから Organizations 配下の全アカウントに CloudFormation Stack を一括配布する仕組み。assume role 不要 (Organizations 統合で自動的に各アカウントで実行される)。
今回配布した Stack の中身は `AWS::ResourceExplorer2::Index` (type: LOCAL) を1つ作るだけのテンプレート。

### Quick Setup = StackSets のラッパー

AWS Systems Manager Quick Setup は、よくある StackSets ベースの設定作業をウィザード化したもの。Resource Explorer 用の Quick Setup テンプレートが AWS に用意されている。

```
Quick Setup (コンソールウィザード)
  → CloudFormation StackSets (裏で自動作成)
    → 各アカウント+リージョンに Stack をデプロイ
      → Stack が LOCAL Index を作成
```

つまり Quick Setup は StackSets を手で組む手間を省くための便利ツール。
