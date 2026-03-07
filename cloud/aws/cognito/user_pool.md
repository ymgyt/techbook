# UserPool

* ApplicationからみるとOIDC IdP
  * IdPに機能を追加したlayer
  * identity federation, app integration, ux customization

## SignUp(ユーザ登録)

* user-driven
  * 有効にするとinternetで誰でもユーザ登録できる
* administrator-driven
* programamatic methods

## Federation

* UserPool単体でOIDC IdPとして振る舞える
* UserPoolと外部のOIDC IdPを連携させると
  * UserPool側で外部IdPのID Tokenを読んでuser poolに追加してくれる
  * 外部IdPとの関係ではUserPoolはSP(Service Provider)
  * App(Client)との関係ではUserPoolはIdP


## Attributes

UserPoolが管理するuser entity毎の属性情報

* `username`
  * 識別子として機能する
  * 外部IdP由来の場合は、`MyIDP_yuta@ymgyt.io`のように固定識別子がつく
  * 設定次第ではsignin時に利用される
  * 変更不可

* `sub`
  * これも識別子
  * 変更不可


## Tier

* Lite
* Essentials
* Plus


## MFA

* Local userのみに影響
* Federated IdPの場合は、IdP側にdelegateするので本設定は影響しない


## Custom Domain

`auth.ymgyt.io` をUserPoolに設定したいとする。

1. ACMで`auth.ymgyt.io`のcertificateを取得する

  ```hcl
  resource "aws_cognito_user_pool" "foo" {
    name                = "foo"
    # omitted...
  }

  resource "aws_cognito_user_pool_domain" "auth" {
    domain          = "auth.ymgyt.io"
    user_pool_id    = aws_cognito_user_pool.foo.id
    certificate_arn = "arn:aws:acm:us-east-1:..."
  }
  ```

  * certificateは`us-east-1` regionに作成する仕様
    * CloudFront distributionで利用するため

  * `ymgyt.io`に値はなんでもよいのでAレコードが必要


2. ALIASレコードで、Cognito用CloudFront distributionを設定する

  ```hcl
  resource "aws_route53_record" "auth" {
    zone_id = aws_route53_zone.myzone.zone_id
    name    = "auth.ymgyt.io"
    type    = "A"

    alias {
      # cognito swpf userpool cloudfront distribution
      name = "[DIST_ID].cloudfront.net"
      # これは仕様で固定
      # CloudFront用alias zone id
      zone_id                = "Z2FDTNDATAQYW2"
      evaluate_target_health = false
    }
  }
  ```
