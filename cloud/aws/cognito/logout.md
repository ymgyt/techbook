# Signout

以下4つの状態がありそれをどう管理するか

* Client/Appの状態
  * SPA memory,session storage, cli token

* Cognito managed login cookie

* 発行されたJWT

* External IdP session


## Client

tokenを消したり、自信のstorage層を管理する話

## Cognito Managed Loging Cookie

* cookieは1時間持続
* `<auth_domain>/logout?client_id=xxx` へ遷移させる必要がある

* `logout_uri`
  * logout後に飛ばしたいページ
  * Logoutしました的なページやなんらかのtop page


## 発行されたJWT

revocation する


## External IdP Session

IdPに依存
