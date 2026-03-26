# OAuth 2.0 On-Behalf-Of (OBO) フロー調査レポート

調査日: 2026-03-27

AI Agent が人間のユーザーに代わって API を呼び出す際の認可パターンとして、On-Behalf-Of (OBO) フローを調査する。対象読者は Authorization Code Grant と Client Credentials Grant を理解しているエンジニア。

## 1. 一言でいうと

OBO は「ユーザー A が AI Agent B を使い、Agent B がユーザー A の代理として API C を呼ぶ」とき、API C が **誰の代理で、誰が実際に行動しているか** を検証可能にする認可フロー。

## 2. なぜ必要か

### 具体的な問題

社内の AI Agent (例: Slack 上の Bot) がユーザーの指示を受けて社内 API を呼ぶ場面を考える。

```
ユーザー A → AI Agent B → API C (社内サービス)
```

既存の OAuth フローで対応しようとすると、以下の問題が生じる。

**方法 1: ユーザーの access token をそのまま Agent に渡す**

- Agent がユーザーの全権限を持つ。scope を Agent 用に絞れない
- API C のログに「ユーザー A がアクセスした」と記録される。Agent が介在した事実が消える
- Agent が token を保持し続けるリスク。token が漏洩するとユーザー A になりすませる

**方法 2: Agent 自身の client credentials で呼ぶ**

- API C には「Agent B がアクセスした」としか見えない。ユーザー A の情報が消える
- ユーザーごとのアクセス制御 (RBAC/ABAC) が効かない
- 監査ログでユーザーの行動を追跡できない

**方法 3: ユーザーの token を HTTP ヘッダーで透過的に転送する**

- API C はユーザー A の token を直接検証するが、Agent B の identity は一切わからない
- Agent が中間者として何をしたかの監査証跡がない
- Agent が異なるスコープで動作している事実を表現できない

いずれの方法でも「**誰 (ユーザー A) の代理で、誰 (Agent B) が行動しているか**」を API C が検証可能な形で表現できない。OBO はこのギャップを埋める。

## 3. メンタルモデル

### アナロジー: 委任状

```
ユーザー A = 依頼人
Agent B    = 代理人 (弁護士)
API C      = 役所の窓口

依頼人が弁護士に委任状を渡す。
委任状には:
  - 誰が依頼人か (ユーザー A の身元)
  - 誰が代理人か (Agent B の身元)
  - 何を委任するか (scope: 住民票の取得のみ、等)
  - いつまで有効か (有効期限)

役所の窓口は委任状を見て:
  1. 依頼人の本人確認 → OK
  2. 代理人の本人確認 → OK
  3. 委任範囲の確認 → 住民票の取得は OK、転居届は NG
  4. 処理を実行し、「A の代理で B が取得」と記録
```

### 技術的なモデル

OBO フローの登場人物と token の流れを示す。

```
┌──────────┐    ┌──────────┐    ┌──────────────────┐    ┌──────────────┐
│  User A  │    │ Agent B  │    │ Authorization    │    │  API C       │
│ (人間)   │    │ (AI)     │    │ Server (IdP)     │    │ (Resource    │
│          │    │          │    │                  │    │  Server)     │
└────┬─────┘    └────┬─────┘    └────────┬─────────┘    └──────┬───────┘
     │               │                   │                     │
     │ 1. Agent を   │                   │                     │
     │    使いたい   │                   │                     │
     │──────────────>│                   │                     │
     │               │                   │                     │
     │ 2. 認可画面   │                   │                     │
     │<──────────────│                   │                     │
     │               │                   │                     │
     │ 3. 同意 (Agent B に scope X を委任)│                     │
     │──────────────────────────────────>│                     │
     │               │                   │                     │
     │               │ 4. Token Exchange │                     │
     │               │   subject_token = A の token            │
     │               │   actor_token   = B の token            │
     │               │──────────────────>│                     │
     │               │                   │                     │
     │               │ 5. OBO token 発行 │                     │
     │               │   sub=A, act={sub:B}                    │
     │               │<──────────────────│                     │
     │               │                   │                     │
     │               │ 6. API 呼び出し (OBO token)             │
     │               │────────────────────────────────────────>│
     │               │                   │                     │
     │               │                   │       7. token 検証 │
     │               │                   │       sub=A → RBAC  │
     │               │                   │       act.sub=B →   │
     │               │                   │         監査記録    │
     │               │                   │       scope → 認可  │
     │               │                   │                     │
     │               │ 8. レスポンス      │                     │
     │               │<────────────────────────────────────────│
```

### OBO token (JWT) の中身

```json
{
  "iss": "https://auth.akeg.me",
  "sub": "user-a-id",
  "azp": "agent-b-client-id",
  "scope": "https://api-c.akeg.me/read",
  "act": {
    "sub": "agent-b-id"
  },
  "exp": 1711540800,
  "iat": 1711537200
}
```

ポイント:

- `sub` = ユーザー A (誰の代理か)
- `act.sub` = Agent B (誰が行動しているか)
- `scope` = 委任された権限の範囲
- API C はこの 3 つを組み合わせて認可判断と監査記録を行う

### token をそのまま転送する場合との違い

| 観点 | token 転送 | OBO |
|---|---|---|
| API C が Agent B の identity を知れるか | No | Yes (`act` claim) |
| scope を Agent 用に絞れるか | No (元の token の scope のまま) | Yes (exchange 時に絞れる) |
| 監査ログに代理関係が残るか | No | Yes |
| token の audience を変えられるか | No (元の audience のまま) | Yes (API C 向けに発行) |

## 4. フロー詳細

RFC 8693 Token Exchange ベースの OBO フローと、draft-oauth-ai-agents-on-behalf-of-user による Authorization Code 拡張の 2 つのアプローチがある。

### 4.1 RFC 8693 Token Exchange ベース

バックチャネルでの token 交換。ユーザーの同意取得は前段の Authorization Code Flow 等で済んでいる前提。

```
Step 1: Agent B は事前にユーザー A の access token (Token-A) を取得済み
        (例: Authorization Code Flow でユーザーがログイン済み)

Step 2: Agent B は自身の client credentials で認証しつつ、
        Token Exchange エンドポイントに以下を送信:

POST /oauth2/token HTTP/1.1
Host: auth.akeg.me
Content-Type: application/x-www-form-urlencoded

grant_type=urn:ietf:params:oauth:grant-type:token-exchange
&subject_token=<Token-A>
&subject_token_type=urn:ietf:params:oauth:token-type:access_token
&actor_token=<Agent-B-token>
&actor_token_type=urn:ietf:params:oauth:token-type:jwt
&scope=https://api-c.akeg.me/read
&audience=https://api-c.akeg.me

Step 3: Authorization Server が検証:
        - subject_token (Token-A) は有効か?
        - actor_token (Agent-B) は信頼された Agent か?
        - 要求された scope は Token-A の scope の範囲内か?
        - ユーザー A は Agent B への委任を同意済みか?

Step 4: 検証 OK なら OBO token を発行:

HTTP/1.1 200 OK
Content-Type: application/json

{
  "access_token": "<OBO-Token>",
  "issued_token_type": "urn:ietf:params:oauth:token-type:access_token",
  "token_type": "Bearer",
  "expires_in": 3600,
  "scope": "https://api-c.akeg.me/read"
}

Step 5: Agent B は OBO token で API C を呼ぶ:

GET /resources HTTP/1.1
Host: api-c.akeg.me
Authorization: Bearer <OBO-Token>

Step 6: API C は OBO token を検証し、sub / act claim から
        代理関係を確認して認可判断を行う
```

### 4.2 draft-oauth-ai-agents-on-behalf-of-user (Authorization Code 拡張)

RFC 8693 はバックチャネル専用で、ユーザーの明示的な同意取得 (フロントチャネル) をカバーしない。この draft は Authorization Code Grant を拡張し、ユーザーが Agent への委任を同意する画面を含む。

```
Step 1: Agent B が Client に対して ActorID を提示

Step 2: Client が Authorization Server にリダイレクト:

GET /authorize?
  response_type=code
  &client_id=<client-id>
  &redirect_uri=<callback>
  &scope=https://api-c.akeg.me/read
  &code_challenge=<PKCE-challenge>
  &code_challenge_method=S256
  &requested_actor=<agent-b-id>        ← 新パラメータ

Step 3: Authorization Server がユーザーに同意画面を表示:
        "Agent B が以下の権限であなたの代理として動作します:
         - api-c.akeg.me の read 権限
         [同意する] [拒否する]"

Step 4: ユーザーが同意 → Authorization Code 発行

Step 5: Client が Token Endpoint で code を交換:

POST /oauth2/token HTTP/1.1
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code
&code=<auth-code>
&redirect_uri=<callback>
&client_id=<client-id>
&code_verifier=<PKCE-verifier>
&actor_token=<agent-b-jwt>             ← 新パラメータ

Step 6: Authorization Server が検証:
        - code は有効か? PKCE は一致するか?
        - actor_token の sub は requested_actor と一致するか?
        - ユーザーはこの Agent + scope の組み合わせに同意したか?

Step 7: OBO token (act claim 付き JWT) を発行

Step 8: Agent B が OBO token で API C を呼ぶ
```

## 5. 既存の OAuth grant type との関係

### Authorization Code Grant で十分でない理由

Authorization Code Grant は「ユーザー → クライアント」の 2 者間の委任を扱う。token の `sub` はユーザー、`azp` はクライアント。

AI Agent のケースでは 3 者が登場する: ユーザー、クライアント (Agent をホストするアプリ)、Agent (実際の行動主体)。Authorization Code Grant の token には Agent の identity を埋め込む標準的な方法がない。

```
Authorization Code: User → Client (2者)
OBO:                User → Client → Agent (3者)
                                     ↑ ここが表現できない
```

### Client Credentials Grant で十分でない理由

Client Credentials はユーザーが介在しない M2M 用。token の principal は client 自身であり、ユーザーの identity を含まない。「ユーザー A の代理で」という情報を伝達できない。

### OBO の位置づけ

| Grant Type | Principal | 用途 | Agent に適するか |
|---|---|---|---|
| Authorization Code | ユーザー | 対話型アプリ | Agent の identity が消える |
| Client Credentials | クライアント (M2M) | バックエンド間通信 | ユーザーの identity が消える |
| Token Exchange (OBO) | ユーザー + Actor | 代理アクセス | 両方の identity を保持 |

OBO は既存の 2 つの grant type を置き換えるものではなく、それらでカバーできない「代理」のユースケースを補完する。

## 6. 標準化の状況

### RFC 8693: OAuth 2.0 Token Exchange (2020-01, RFC)

OBO の基盤となる仕様。RFC として確定済み。

- grant type: `urn:ietf:params:oauth:grant-type:token-exchange`
- `subject_token` + `actor_token` による delegation モデルを定義
- 発行される token に `act` claim を含めることで代理関係を表現
- **Cognito は未サポート**

### draft-oauth-ai-agents-on-behalf-of-user-01 (2025-05, Individual Draft)

AI Agent 専用の OBO 拡張。

| 項目 | 内容 |
|---|---|
| Version | 01 |
| Date | 2025-05-08 |
| Expires | 2025-11-09 |
| Status | Informational (Individual Draft, WG 未採択) |
| Authors | T.S. Senarath, A. Dissanayaka (WSO2) |

Authorization Code Grant に `requested_actor` / `actor_token` パラメータを追加し、フロントチャネルでのユーザー同意を可能にする。RFC 8693 がバックチャネル専用であることを補完する位置づけ。

**注意**: Individual Draft であり、OAuth WG に正式採択されていない。今後大きく変わる可能性がある。

### draft-ietf-oauth-identity-chaining-08 (2026-02, WG Draft)

ドメイン間での identity と authorization の連鎖を扱う。

| 項目 | 内容 |
|---|---|
| Version | 08 |
| Date | 2026-02-09 |
| Status | Proposed Standard (IESG 提出済み) |

RFC 8693 Token Exchange + RFC 7523 JWT Bearer を組み合わせ、異なる trust domain 間で代理関係を伝搬する仕組み。OBO の cross-domain 版。AI Agent が外部サービスを呼ぶ A2A シナリオで重要になる。WG Draft として進んでおり、RFC 化に近い段階。

### 全体像

```
RFC 8693 Token Exchange (RFC, 2020)
  ├── 基盤: subject_token + actor_token → act claim
  │
  ├── draft-oauth-ai-agents-on-behalf-of-user-01 (Individual, 2025)
  │     フロントチャネルのユーザー同意を追加
  │
  └── draft-ietf-oauth-identity-chaining-08 (WG Draft → Proposed Standard)
        cross-domain での identity 連鎖
```

## 7. Cognito との関係

### 現時点の Cognito の対応状況

**Token Exchange (RFC 8693): 未サポート**

Cognito の `/oauth2/token` エンドポイントは以下の grant type のみ対応:

- `authorization_code`
- `client_credentials`
- `refresh_token`

`urn:ietf:params:oauth:grant-type:token-exchange` を送信するとエラーになる。

**act claim: 未サポート**

Cognito が発行する JWT にカスタム claim として `act` を追加する標準的な方法がない。Pre Token Generation Lambda Trigger (V2) で `claimsAndScopeOverrideDetails` を使えば claim の追加・上書きは可能だが、`act` のようなネストした JSON object を claim として追加できるかは未検証。

**requested_actor パラメータ: 未サポート**

Cognito の `/oauth2/authorize` エンドポイントは `requested_actor` パラメータを認識しない。

### OBO を実現するために必要なもの

Cognito 単体では OBO をサポートできない。対応するには Cognito の前段にカスタムレイヤーを構築する必要がある。

```
                     ┌─────────────────────────────┐
                     │     カスタムレイヤー          │
                     │  (API Gateway + Lambda)      │
                     │                              │
  Client ──────────> │  /token-exchange endpoint    │
  (Token Exchange    │    1. subject_token 検証     │
   リクエスト)       │    2. actor_token 検証       │
                     │    3. ポリシー評価           │
                     │    4. OBO token (JWT) 発行   │
                     │       - sub = ユーザー       │
                     │       - act = {sub: Agent}   │
                     │       - scope = 委任範囲     │
                     │                              │
                     │  Cognito を信頼の起点として: │
                     │    - JWKS で token 検証      │
                     │    - ユーザー情報の参照      │
                     └─────────────────────────────┘
                                  │
                                  │ Cognito の JWKS / UserInfo
                                  ▼
                     ┌─────────────────────────────┐
                     │  Cognito User Pool           │
                     │  (ユーザー管理, IdP 連携,    │
                     │   標準 OAuth フロー)         │
                     └─────────────────────────────┘
```



### 8.1 インフラ変更

| コンポーネント | 変更内容 |
|---|---|
| API Gateway | Token Exchange エンドポイント (`/oauth2/token-exchange` 等) を追加 |
| Lambda | Token Exchange ロジックの実装: token 検証、ポリシー評価、JWT 署名・発行 |
| KMS | OBO token 署名用の鍵管理。Cognito の JWKS とは別の鍵ペアが必要 |
| JWKS エンドポイント | カスタムレイヤーが発行する JWT の公開鍵を配信。Resource Server が OBO token を検証するために必要 |

### 8.3 ポリシーエンジン

Token Exchange 時に「ユーザー A は Agent B に scope X を委任してよいか」を判断するポリシーが必要。単純な実装では:

- 許可する (user, agent, scope) の組み合わせをテーブルで管理
- Lambda が Token Exchange 時にこのテーブルを参照

### 8.4 Resource Server 側の変更

OBO token を受け取る Resource Server は、token 検証ロジックを更新する必要がある:

- カスタムレイヤーの JWKS で署名を検証 (Cognito の JWKS とは別)
- `act` claim の存在を確認し、代理関係を監査ログに記録
- `sub` (ユーザー) に基づく RBAC/ABAC と、`act.sub` (Agent) に基づくアクセス制御を組み合わせる


## References

- [RFC 8693 OAuth 2.0 Token Exchange](https://datatracker.ietf.org/doc/html/rfc8693)
- [draft-oauth-ai-agents-on-behalf-of-user-01](https://www.ietf.org/archive/id/draft-oauth-ai-agents-on-behalf-of-user-01.html)
- [draft-ietf-oauth-identity-chaining-08](https://datatracker.ietf.org/doc/draft-ietf-oauth-identity-chaining/)
