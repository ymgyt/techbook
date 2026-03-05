# PKCE

* RFC7636
* 読み方はpixy
* OAuth2.0の認可コード flowにおいて、攻撃者が認可コードを横取りしてtokenをえることを防ぐ仕組み

## 仕組み　

* token取得時に認可serverへのrequestに`code_verifier` parameterを要求する
* 認可serverはtoken払い出し時に`code_verfier`を`hash(code_vefier) == code_challenge`を検証する
  * `code_challenge`は`/authorize`(認可リクエスト)開始時に、clientが生成する

* 攻撃者は`code_verifier`を知らないので、認可コードだけ横取りしてもtokenをえられない
