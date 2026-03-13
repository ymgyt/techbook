# Flow

## Authorization Code Flow

1. BrowserがIdP Authroization endpointにリクエストを送信
  * IdPのログイン画面が表示される

2. UserがIdPでログインするとRedirect endpointにむけて302を返す

  ```text
  HTTP/1.1 302 Found
  Location: https://client.example.com/callback?code=abc123&state=xyz
  Cache-Control: no-store
  Pragma: no-cache
  ```

  * redirect時のparamにログインできたという情報がのっている

3. Broswerは302にしたがって、Authorization CodeをともなってClientのRedirect endpointにアクセス

4. ClientはIdPのToken endpointにアクセスしてAuthorization codeを渡す

5. IdPはTokenを発行しClientに返す


### SPAにAuthorization Codeを渡す方法

1. IdPログイン後に302 Location: `https://client.ymgyt.io?code=123`を返す

2. `https://client.ymgyt.io?code=123`からhtml,jsがserveされ、SPAが起動する

3. SPAがURLから`code=123`を取得してIdP Token endpointからtokenを取得する


## Implicit Flow

* IdPからのRedirectにflagment(`#`)でID tokenが渡される
  * flagmentはserverには送られない仕様を利用

* 非推奨
  * OAuth 2.1からは削除予定

## Hybrid Flow

* 非推奨


## Client Credential Flow

1. ClientはClientID,ClientSecretを付与してIdP Token endpointにアクセス

2. IdPからAccess tokenをもらう


## ResourceOwner Password Credential Flow

* 非推奨
