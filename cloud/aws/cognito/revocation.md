# Revocation

Tokenの無効化について

## Revocation interface

複数の方法がある。

* `RevokeToken` cognito API
  * https://docs.aws.amazon.com/cognito-user-identity-pools/latest/APIReference/API_RevokeToken.html
  * IAMによる認証認可が介在しない
  * Inputは client_id, client_secret(confidentialの場合), refresh_token

* `<custom domain>/oauth2/revoke`
  * RFC7009

| パラメータ  | 必須               | 説明                                              |
|-------------|--------------------|---------------------------------------------------|
| `token`     | Yes                | 無効化する refresh token                          |
| `client_id` | Public client のみ | Confidential client は Authorization ヘッダで認証 |

Public client:

```sh
curl -X POST https://auth.ymgyt.io/oauth2/revoke \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d "token=${REFRESH_TOKEN}&client_id=${CLIENT_ID}"
```

Confidential client:

```sh
curl -X POST https://auth.ymgyt.io/oauth2/revoke \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H "Authorization: Basic $(echo -n "${CLIENT_ID}:${CLIENT_SECRET}" | base64)" \
  -d "token=${REFRESH_TOKEN}"
```

レスポンス:

| HTTP Status   | エラー                   | 意味                                                         |
|---------------|--------------------------|--------------------------------------------------------------|
| 200 (空 body) | \-                       | 成功。既に無効化済み / 不正な token でも 200 (RFC 7009 準拠) |
| 400           | `invalid_request`        | token パラメータ欠落 or revocation が無効化されている        |
| 400           | `unsupported_token_type` | refresh token 以外を渡した                                   |
| 401           | `invalid_client`         | client 認証失敗                                              |
  
