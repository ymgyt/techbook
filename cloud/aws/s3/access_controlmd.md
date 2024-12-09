# S3 Access Control

歴史的経緯からIAMより先にあるので複数の方法がある


## Bucket Policy

* Resource側からのaccess 制御
  * IAMのresource based policyのこと


## ACL

* 非推奨だが知っておく必要がある
* 被付与者(grantee) に bucket/object への access を許可する
* **CloudFrontのlogを書き込む場合には有効にしておく必要がある**
* `aws s3api get-object-acl` で取得できる

### Grantee

* AWS Account
  * Canonical User ID(正規ユーザID) で AWS accountを識別する
* 事前定義済みS3 group
  * All Users Group(世界中の誰でも)
  * Authenticated Users Group (任意のAWS Account = 誰でも)
  * Log Delivery Group

### Access 許可

* READ
* WRITE
* READ_ACP
* WRITE_ACP
* FULL_CONTROL


## Object Ownership

* bucket levelの設定
* ACLを無効にする
  * Bucket owner enforced
* ACLを有効にする
  * Bucket owner preferred
  * Object wirter


## References

* [S3でACLを無効化できるようになった](https://dev.classmethod.jp/articles/s3-bucket-owner-enforced/)
