# CDK Concepts

## Construct

* represents "cloud component"
  * 再利用の単位
  * CloudFormationをどの程度抽象化しているかでL1とL2に分かれる
  * CDK v2から、`constructs` moduleに分離された(v1ではcore)

### Construct Layer

* L1.CfnResource
  * Cloudformationに対応する
* L2. intent-based API
  * default値を設定してくれている
  * `bucket.addLifeCycleRule()`とかでbucketの設定できるイメージ
