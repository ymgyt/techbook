# Cookie

## 生成

Serverの`set-cookie: session=abc123`

## 属性

* `SameSite`
* `Expires`: cookieの失効時間
* `Max-Age`: cookieの有効期間
* `Secure`: cookieがhttps上でのみ送信される
* `HttpOnly`: jsの`Document.cookie`でアクセスできない
* `Domain`: cookieの送信対象ドメインの指定

### SameSite

Cookieの送信判定に利用する粒度

* `Strict`
  * same-siteの場合だけ送る

* `Lax`
  * same-siteでは送る
  * 他サイトのリンクをクリックして自分のサイトへ遷移する場合に送る
