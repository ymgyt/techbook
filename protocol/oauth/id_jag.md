# ID-JAG

Identity Assertion JWT Aurhorization Grant

https://datatracker.ietf.org/doc/html/draft-ietf-oauth-identity-assertion-authz-grant-02

Abstruct:
> This specification provides a mechanism for an application to use an identity assertion to obtain an access token for a third-party API by coordinating through a common enterprise identity provider using Token Exchange [RFC8693] and JWT Profile for OAuth 2.0 Authorization Grants

Third party APIのaccess tokenをenterprise IdPのjwtを利用して取得するmechanism.
Token Exchange [RFC8693] とJWT Profile for OAuth 2.0 Authorization Grants [RFC7523]を利用する

## 2. なぜ必要か

Authorization Code と Client Credentials だけでは解決しにくいユースケースがある。

### ユースケース 1: 異なる IdP 間でのトークン交換

Service A は IdP X から発行された JWT を持っている。この JWT を使って Authorization Server Y からアクセストークンを取得したい。ユーザー操作 (ブラウザリダイレクト) なしで。

```
Service A が持つもの: IdP X が発行した JWT
欲しいもの:          AS Y が発行するアクセストークン
制約:                ユーザー操作不可 (バックエンド処理)
```

Authorization Code はブラウザが必要。Client Credentials はクライアント自身の認証であり、ユーザーの identity を伝えられない。JWT Bearer はこのギャップを埋める。

### ユースケース 2: MCP Enterprise-Managed Authorization

MCP Client は企業 IdP (Okta, Azure AD 等) から ID-JAG (Identity Assertion JWT Authorization Grant) を受け取っている。これを MCP Server の AS に提示してアクセストークンを取得する。企業の IdP が「このユーザーはこの MCP Server を使ってよい」と判断した証拠として ID-JAG を発行し、MCP Server の AS はそれを検証してアクセストークンを返す。

### ユースケース 3: リダイレクトなしのクロスドメイン SSO

ユーザーが既に IdP A で認証済みの場合、その JWT を IdP B に提示してアクセストークンを取得できる。ブラウザのリダイレクトチェーンが不要になるため、バックエンドサービスや CLI ツールからの利用に適している。

## 3. メンタルモデル

### 紹介状のアナロジー

JWT Bearer は**紹介状**に相当する。

- 信頼できる人物 (JWT の発行者) が署名した紹介状 (JWT assertion) を持参する
- 訪問先 (Authorization Server) はその紹介状の署名を検証し、発行者を信頼していれば入館証 (アクセストークン) を発行する
- 紹介状には「誰が」「誰のために」「どこ向けに」「いつまで有効か」が記載されている

### Authorization Code との違い

| 観点 | Authorization Code | JWT Bearer |
|---|---|---|
| ブラウザリダイレクト | 必要 | 不要 |
| ユーザー操作 | 同意画面等が必要 | 不要 (事前に認証済み) |
| 利用シーン | ユーザーがブラウザで操作中 | バックエンド間、CLI、既に JWT を保持している場合 |

Authorization Code はユーザーが「今ここで」認可する。JWT Bearer は「既に別の場所で発行された証拠」を使う。

### Client Credentials との違い

| 観点 | Client Credentials | JWT Bearer |
|---|---|---|
| 主体 | クライアント (アプリケーション) | ユーザー or クライアント |
| Identity の種類 | クライアント ID + シークレット | JWT に含まれる sub (ユーザー情報) |
| ユースケース | M2M (Machine-to-Machine) | ユーザーの identity を伝えつつ、リダイレクトなしでトークン取得 |

Client Credentials は「このアプリケーションは誰か」を証明する。JWT Bearer は「このユーザーは誰か」を第三者の署名付きで伝える。

### 信頼関係の前提

JWT Bearer が成立するには以下の信頼関係が必須:

```
JWT 発行者 (IdP X)  ----信頼--->  Authorization Server Y
       |                                    |
     JWT に署名               署名を検証 (JWKS で公開鍵取得)
       |                                    |
       v                                    v
   JWT assertion  -----提示----->   アクセストークン発行
```

AS Y は IdP X の公開鍵 (JWKS エンドポイント等) を事前に知っている必要がある。信頼していない発行者の JWT は拒否される。

## 4. フロー詳細

### ステップ 1: JWT assertion の準備

クライアントは信頼された IdP から JWT を取得済み。この JWT が assertion としてそのまま使われるか、IdP に依頼して専用の assertion を発行してもらう。

### ステップ 2: トークンエンドポイントへの POST

```http
POST /oauth2/token HTTP/1.1
Host: as.example.com
Content-Type: application/x-www-form-urlencoded

grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Ajwt-bearer
&assertion=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2lkcC5leGFtcGxlLmNvbSIsInN1YiI6InVzZXIxMjMiLCJhdWQiOiJodHRwczovL2FzLmV4YW1wbGUuY29tIiwiZXhwIjoxNzExNTQ0MDAwLCJpYXQiOjE3MTE1NDA0MDB9.signature
&scope=read+write
```

パラメータ:

| パラメータ   | 値                                            | 説明                               |
|--------------|-----------------------------------------------|------------------------------------|
| `grant_type` | `urn:ietf:params:oauth:grant-type:jwt-bearer` | JWT Bearer グラントを示す固定値    |
| `assertion`  | JWT 文字列                                    | 発行者が署名した JWT。1 つだけ含む |
| `scope`      | (任意)                                        | 要求するスコープ                   |

### ステップ 3: AS の検証処理

1. JWT の署名を検証 (発行者の公開鍵を使用)
2. `iss` が信頼された発行者か確認
3. `aud` が自身 (AS) を指しているか確認
4. `exp` が現在時刻より未来か確認
5. `sub` からユーザーを特定
6. (オプション) `jti` で replay attack を検出

### ステップ 4: アクセストークンの発行

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "access_token": "eyJhbGciOiJSUzI1NiIs...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "scope": "read write"
}
```

## 5. JWT assertion の要件

RFC 7523 Section 3 が定める JWT assertion の要件。

### 必須 (MUST)

| Claim | 要件 |
|---|---|
| `iss` | JWT 発行者の一意な識別子。AS はこの値で発行者を特定し、署名検証に使う鍵を決定する |
| `sub` | JWT の主体 (subject) を識別する claim。AS はこの値でユーザーまたはクライアントを特定する |
| `aud` | AS を audience として含む。AS のトークンエンドポイント URL か、AS の識別子を使用。AS は自身が意図された受信者であることを確認する |
| `exp` | JWT の有効期限。AS は現在時刻がこの値を超えていたら拒否する |
| 署名 | JWT は発行者によるデジタル署名または MAC が適用されていなければならない |

### 任意 (MAY)

| Claim | 要件 |
|---|---|
| `nbf` | この時刻より前は JWT を受け付けてはならない (MUST NOT) |
| `iat` | JWT の発行時刻 |
| `jti` | JWT の一意識別子。replay attack の検出に使用。AS は同じ `jti` の JWT を再度受け付けないようにできる |

### JWT assertion の例

```json
{
  "alg": "RS256",
  "typ": "JWT",
  "kid": "idp-signing-key-1"
}
.
{
  "iss": "https://idp.example.com",
  "sub": "user123",
  "aud": "https://as.example.com",
  "exp": 1711544000,
  "iat": 1711540400,
  "jti": "unique-token-id-abc123"
}
.
[signature]
```

## 6. 2 つの用途

RFC 7523 は JWT を 2 つの目的で使用する方法を定義している。

### 6.1 Authorization Grant として (Section 2.1)

JWT をアクセストークン取得のためのグラントとして使用する。前述のフローがこれに該当する。

```
grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer
assertion=<JWT>
```

**用途**: 別の IdP が発行した JWT を提示してアクセストークンを取得する。ユーザーの identity を伝達するのが主目的。

### 6.2 Client Authentication として (Section 2.2)

JWT を client\_secret の代わりにクライアント認証手段として使用する。他のグラントタイプ (`authorization_code`, `client_credentials` 等) と組み合わせて使う。

```
grant_type=authorization_code
&code=auth-code-value
&client_assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer
&client_assertion=<JWT>
```

**用途**: `client_secret` の代わりに署名付き JWT でクライアントを認証する。秘密鍵の保持を証明するため、shared secret よりセキュアとされる。

### 違いのまとめ

| 観点 | Authorization Grant (2.1) | Client Authentication (2.2) |
|---|---|---|
| パラメータ名 | `assertion` | `client_assertion` |
| `grant_type` | `urn:...:jwt-bearer` | 他のグラントタイプ (例: `authorization_code`) |
| 何を証明するか | ユーザーまたは主体の identity | クライアントの identity |
| 何を置き換えるか | Authorization Code 等のグラント | `client_id` + `client_secret` |

