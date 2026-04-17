# OpenID Connect PR-Initiated Logout 1.0

https://openid.net/specs/openid-connect-rpinitiated-1_0.html

## 概要

1. UserがLogout ボタンを押す
2. Clientが自分のsessionを破棄
3. ClientはbrowserにIdPに対するログアウトリクエストを送る
  * SPAの場合はbroserに送らせる
4. IdPはsessionを破棄する
5. IdPはClientをログアウトページにredirectさせる
  * 事前登録が必要
6. ログアウトページを表示
