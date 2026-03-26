# OAuth 2.0 Token Exchange

## 1. 一言でいうと

Token Exchange は「手持ちのトークンを Authorization Server に差し出して、別の性質を持つトークンを発行してもらう」ための OAuth 2.0 拡張グラントタイプ (RFC 8693) である。

## 2. なぜ必要か

Authorization Code Grant や Client Credentials Grant だけでは対処できないシナリオがある。

### ケース 1: マイクロサービス間のトークン変換

Service A がユーザーのアクセストークン (audience=A) を受け取った。Service A は処理の一部を Service B に委譲したいが、Service B は audience=B のトークンしか受け付けない。

```
User --> Service A (token: aud=A) --> Service B (token: aud=B が必要)
```

Service A がユーザーに再度ログインさせるわけにはいかない。Token Exchange を使えば、Service A は AS に対して「このユーザーの token を audience=B に変換してくれ」と要求できる。

### ケース 2: 企業 IdP から外部 SaaS への認証連携 (MCP Enterprise-Managed Authorization)

企業 IdP で認証済みのユーザーが、外部 SaaS の MCP Server にアクセスしたい。SaaS 側は独自の AS を持っており、企業 IdP のトークンを直接受け入れない。

```
User --> 企業 IdP (ID Token) --> Token Exchange --> ID-JAG --> SaaS AS (access token)
```

企業 IdP は ID Token を入力として受け取り、Token Exchange で ID-JAG (Identity Assertion JWT Authorization Grant) を発行する。SaaS 側の AS はこの ID-JAG を検証して access token を発行する。

### ケース 3: Impersonation (なりすまし)

管理者がサポート対応のためにユーザー X として操作したい。管理者のトークンを入力として、ユーザー X のトークンを発行する。Audit log には「管理者がユーザー X として操作した」記録が残る必要がある。

## 3. メンタルモデル

### 直感的な理解

Token Exchange は両替所のようなもの。

- 手持ちの通貨 (subject\_token) を窓口 (token endpoint) に出す
- 「どの通貨に換えてほしいか」(requested\_token\_type) を伝える
- 両替所はレートとルール (ポリシー) に基づいて交換可否を判断する
- 別の通貨 (issued\_token) を受け取る

### 技術モデル

Token Exchange は既存の `/token` エンドポイントに対して `grant_type=urn:ietf:params:oauth:grant-type:token-exchange` を指定することで動作する。新しいエンドポイントは不要。

#### 主要パラメータ

| パラメータ | 必須 | 説明 |
|---|---|---|
| `grant_type` | Yes | `urn:ietf:params:oauth:grant-type:token-exchange` (固定) |
| `subject_token` | Yes | 交換元のトークン。リクエストの「主語」にあたるセキュリティトークン |
| `subject_token_type` | Yes | subject\_token の種類を示す URI |
| `actor_token` | No | 委任 (delegation) 時に、実際に行動する主体のトークン |
| `actor_token_type` | No | actor\_token の種類を示す URI。actor\_token がある場合は必須 |
| `resource` | No | 発行されるトークンの対象リソース (URI) |
| `audience` | No | 発行されるトークンの対象サービス (論理名) |
| `scope` | No | 要求するスコープ |
| `requested_token_type` | No | 発行してほしいトークンの種類 |

#### トークンタイプ識別子

RFC 8693 で定義されている標準の token type URI:

| URI | 意味 |
|---|---|
| `urn:ietf:params:oauth:token-type:access_token` | OAuth 2.0 access token |
| `urn:ietf:params:oauth:token-type:refresh_token` | OAuth 2.0 refresh token |
| `urn:ietf:params:oauth:token-type:id_token` | OIDC ID Token |
| `urn:ietf:params:oauth:token-type:saml1` | SAML 1.1 Assertion |
| `urn:ietf:params:oauth:token-type:saml2` | SAML 2.0 Assertion |
| `urn:ietf:params:oauth:token-type:jwt` | 汎用 JWT |

独自の token type URI を定義することも可能 (例: ID-JAG 用の URI)。

#### subject\_token vs actor\_token

- **subject\_token**: 「誰のために」動くかを示す。ユーザー A のトークンがここに入る
- **actor\_token**: 「誰が」動くかを示す。Service X のトークンがここに入る

```
subject_token = ユーザー A の ID Token
actor_token   = Service X の access token

→ 発行されるトークン: "Service X がユーザー A の代理として動く" ことを表す
```

actor\_token がない場合は impersonation (なりすまし) となる。発行されるトークンはあたかも subject 自身が直接発行したかのように振る舞う。

#### may\_act claim

delegation chain を表現するための JWT claim。「このトークンの subject に対して act できる主体」を宣言する。

```json
{
  "sub": "user-a@example.com",
  "may_act": {
    "sub": "service-x",
    "iss": "https://as.example.com"
  }
}
```

AS はこの claim を検証し、actor\_token の主体が may\_act で許可されているか確認できる。

発行されたトークンには `act` claim が含まれ、delegation chain を記録する:

```json
{
  "sub": "user-a@example.com",
  "act": {
    "sub": "service-x",
    "iss": "https://as.example.com"
  }
}
```

## 4. フロー詳細

### リクエスト

```http
POST /oauth2/token HTTP/1.1
Host: as.example.com
Content-Type: application/x-www-form-urlencoded
Authorization: Basic <client_credentials>

grant_type=urn:ietf:params:oauth:grant-type:token-exchange
&subject_token=eyJhbGciOiJSUzI1NiIs...
&subject_token_type=urn:ietf:params:oauth:token-type:access_token
&audience=service-b
&requested_token_type=urn:ietf:params:oauth:token-type:access_token
```

- `Authorization` ヘッダーまたは `client_id` / `client_secret` パラメータでクライアント認証する
- subject\_token に「今持っているトークン」をそのまま渡す

### レスポンス (成功)

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "access_token": "eyJhbGciOiJSUzI1NiIs...",
  "issued_token_type": "urn:ietf:params:oauth:token-type:access_token",
  "token_type": "Bearer",
  "expires_in": 3600,
  "scope": "service-b.read service-b.write"
}
```

- `issued_token_type` は実際に発行されたトークンの種類。requested\_token\_type と異なる場合がある (AS のポリシー次第)
- `token_type` は RFC 6749 と同じ。通常 `Bearer`

### Delegation の場合のリクエスト (actor\_token あり)

```http
POST /oauth2/token HTTP/1.1
Host: as.example.com
Content-Type: application/x-www-form-urlencoded
Authorization: Basic <client_credentials>

grant_type=urn:ietf:params:oauth:grant-type:token-exchange
&subject_token=eyJ...(user A の token)
&subject_token_type=urn:ietf:params:oauth:token-type:access_token
&actor_token=eyJ...(service X の token)
&actor_token_type=urn:ietf:params:oauth:token-type:access_token
&audience=service-b
```

### エラーレスポンス

```http
HTTP/1.1 400 Bad Request
Content-Type: application/json

{
  "error": "invalid_grant",
  "error_description": "subject_token is expired"
}
```

標準の OAuth 2.0 エラーコード (RFC 6749 Section 5.2) に従う。

## 5. 4 つのパターン

### パターン 1: Delegation (委任)

「ユーザー A の代理として Service X が動く」ことを明示する。

```
Input:  subject_token = User A の token
        actor_token   = Service X の token
Output: User A の sub + act: { sub: "service-x" } を持つトークン
```

発行されたトークンには `act` claim が入り、誰が代理しているかが追跡可能。subject と actor の両方の identity が保持される。

**ユースケース**: マイクロサービスがユーザーのリクエストを下流サービスに委譲する場合。

### パターン 2: Impersonation (なりすまし)

「ユーザー A として振る舞う」。actor\_token を使わない。

```
Input:  subject_token = Admin の token (+ AS のポリシーで対象ユーザーを指定)
Output: User A の sub を持つトークン (act claim なし)
```

受け取り側のサービスからは、ユーザー A が直接操作したのと区別がつかない。AS 側の audit log でのみ追跡可能。

**ユースケース**: カスタマーサポートがユーザーの問題を再現する場合。強い権限のため、慎重なポリシー設定が必要。

### パターン 3: Cross-Domain (audience 変換)

同一ユーザーのトークンを、異なる audience (対象サービス) 向けに再発行する。

```
Input:  subject_token = User A の token (aud=service-a)
        audience      = service-b
Output: User A の token (aud=service-b)
```

**ユースケース**: マイクロサービス A が受け取ったトークンを、マイクロサービス B 用に変換する。Section 2 のケース 1 がまさにこれ。

### パターン 4: Token Type 変換

トークンの形式を変換する。

```
Input:  subject_token      = SAML 2.0 Assertion
        subject_token_type = urn:ietf:params:oauth:token-type:saml2
        requested_token_type = urn:ietf:params:oauth:token-type:access_token
Output: OAuth 2.0 access token
```

**ユースケース**:
- SAML → OAuth 2.0 への移行期間中のブリッジ
- access\_token → id\_token への変換
- ID Token → ID-JAG (カスタムトークンタイプ) への変換

## 6. MCP Enterprise-Managed Authorization での利用

[SEP-646](https://github.com/modelcontextprotocol/modelcontextprotocol/pull/646) は、企業が MCP Client-Server 間の認可を一元管理するためのプロファイルを定義する。その中核に Token Exchange がある。

### 課題

デフォルトの MCP 認可フローでは:

- ユーザーが MCP Client-Server ペアごとに個別に認可する必要がある
- 企業管理者がアクセス制御を一元管理できない
- 各 SaaS の AS に企業の IdP を直接 federation させるのは現実的でない

### ID-JAG (Identity Assertion JWT Authorization Grant)

ID-JAG は [draft-ietf-oauth-identity-assertion-authz-grant](https://datatracker.ietf.org/doc/draft-ietf-oauth-identity-assertion-authz-grant/) で定義される JWT。企業 IdP が「このユーザーは認証済みであり、この MCP Server へのアクセスを企業ポリシーが許可している」ことを assertion する。

### フロー

```
MCP Client          企業 IdP              SaaS MCP AS         SaaS MCP Server
    |                   |                      |                     |
    |-- AuthZ Code ---->|                      |                     |
    |<-- ID Token ------|                      |                     |
    |                   |                      |                     |
    |== Token Exchange =|                      |                     |
    |  subject_token    |                      |                     |
    |  = ID Token       |                      |                     |
    |  requested_type   |                      |                     |
    |  = id-jag         |                      |                     |
    |  audience         |                      |                     |
    |  = SaaS MCP AS    |                      |                     |
    |                   |                      |                     |
    |  (IdP がポリシー   |                      |                     |
    |   評価)            |                      |                     |
    |                   |                      |                     |
    |<-- ID-JAG --------|                      |                     |
    |                   |                      |                     |
    |---------- Token Request (ID-JAG) ------->|                     |
    |                   |   (AS が ID-JAG 検証) |                     |
    |<--------- MCP Access Token --------------|                     |
    |                   |                      |                     |
    |---------------------- API Call (Access Token) ----------------->|
    |<--------------------- Response --------------------------------|
```

### Token Exchange リクエスト (ID Token → ID-JAG)

```http
POST /oauth2/token HTTP/1.1
Host: idp.example.com
Content-Type: application/x-www-form-urlencoded
Authorization: Basic <mcp_client_credentials>

grant_type=urn:ietf:params:oauth:grant-type:token-exchange
&subject_token=eyJ...(ID Token)
&subject_token_type=urn:ietf:params:oauth:token-type:id_token
&requested_token_type=urn:ietf:params:oauth:token-type:id-jag
&audience=https://saas-mcp.example.com
```

### なぜ ID-JAG を挟むのか

直接 ID Token を SaaS 側に渡す方式にしない理由:

1. **AS の独立性**: SaaS 側の AS は自前でトークン (有効期限、scope、revocation) を管理したい。企業 IdP のトークンをそのまま bearer token にすると制御が SaaS 側から離れる
2. **ポリシー適用ポイント**: 企業 IdP が Token Exchange 時にポリシー (「この MCP Server へのアクセスは許可されているか」) を評価できる
3. **最小権限**: ID-JAG は特定の audience に束縛され、短い有効期限を持つ。ID Token をそのまま使い回すより安全

## 7. Cognito との関係

**Cognito は RFC 8693 Token Exchange をサポートしていない。**

Cognito の `/oauth2/token` エンドポイントが受け付ける grant\_type は以下のみ:

- `authorization_code`
- `refresh_token`
- `client_credentials`

`urn:ietf:params:oauth:grant-type:token-exchange` を送ると単にエラーになる。

## 8. よくある混同

### Token Exchange vs Token Refresh

| | Token Exchange (RFC 8693) | Token Refresh (RFC 6749 Section 6) |
|---|---|---|
| 目的 | トークンの性質を変える (audience、type、subject) | 同じトークンの有効期限を延長する |
| grant\_type | `urn:ietf:params:oauth:grant-type:token-exchange` | `refresh_token` |
| 入力 | 任意のセキュリティトークン (access token, ID Token, SAML 等) | refresh token のみ |
| 出力 | 入力とは異なる性質のトークン | 同じ性質の新しい access token (+ 新しい refresh token) |
| Subject | 変わりうる (impersonation) | 常に同一ユーザー |

Refresh は「同じ切符の期限延長」、Exchange は「別の切符への交換」。

### Token Exchange vs Authorization Code Exchange

Authorization Code Flow で `code` を `token` に交換する操作は「Token Exchange」とは呼ばない。

| | Token Exchange (RFC 8693) | Authorization Code → Token |
|---|---|---|
| RFC | 8693 | 6749 Section 4.1.3 |
| grant\_type | `urn:ietf:params:oauth:grant-type:token-exchange` | `authorization_code` |
| 入力 | 既存のセキュリティトークン | Authorization Code (一回限りの認可コード) |
| 前提 | トークンが既に存在する | ユーザーが認可画面で同意した直後 |
| 用途 | トークン変換・委任・なりすまし | 初回のトークン取得 |

Authorization Code はセキュリティトークンではなく一時的な認可コードであり、Token Exchange の subject\_token には使えない。

## References

- [RFC 8693 -- OAuth 2.0 Token Exchange](https://datatracker.ietf.org/doc/html/rfc8693)
- [draft-ietf-oauth-identity-assertion-authz-grant -- Identity Assertion JWT Authorization Grant](https://datatracker.ietf.org/doc/draft-ietf-oauth-identity-assertion-authz-grant/)
- [SEP-646 -- Enterprise-Managed Authorization](https://github.com/modelcontextprotocol/modelcontextprotocol/pull/646)
- [draft-ietf-oauth-identity-chaining -- OAuth Identity and Authorization Chaining Across Domains](https://datatracker.ietf.org/doc/draft-ietf-oauth-identity-chaining/)
