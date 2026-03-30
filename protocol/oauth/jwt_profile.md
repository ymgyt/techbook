# JWT Profile for OAuth 2.0 Client Authentication and Authorization Grants

[RFC 7523](https://datatracker.ietf.org/doc/html/rfc7523)

**課題**: あるシステムが署名付き JWT (OIDC token, サービスアカウントキー等) を既に持っていて、別の AS の access token がほしい。しかし標準の OAuth フロー (Authorization Code, Client Credentials) はどれも合わない:

- Authorization Code: ブラウザリダイレクトが必要。サーバーサイドやバッチ処理では使えない
- Client Credentials: client_secret ベース。外部 IdP が発行した JWT を信頼する仕組みがない

外部の IdP が発行した JWT を、別の AS が信頼して access token に変換する標準的な方法がない。

**解決**: `grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer` で、署名付き JWT を AS の token endpoint に提示し、access token を取得する。

- AS は JWT の署名を発行者の JWKS で検証する
- `aud` が AS 自身であることを確認する
- JWT の claims (issuer, subject 等) に基づいて access token を発行する

**具体例 1**: GitHub Actions → Idp

```
1. GitHub Actions の workflow が OIDC token を取得
   (issuer: token.actions.githubusercontent.com, audience: idp.ymgyt.io)

2. workflow が idpstack の token endpoint に JWT Bearer Grant を実行:
     grant_type = urn:ietf:params:oauth:grant-type:jwt-bearer
     assertion = <GitHub OIDC token>

3. idpstack が GitHub の JWKS で署名を検証
   → issuer, audience, exp を確認
   → claims (repository, environment 等) を評価

4. idpstack が access token を発行
   → scope: styx-api/write
   → カスタム claims: repository=arkedge/foo

5. workflow が access token で社内 API を呼ぶ
```

**具体例 2**: ID-JAG の第 2 ステップ

```
1. Claude Code が企業 IdP (idpstack) から ID-JAG を取得済み
   (issuer: idp.ymgyt.io, audience: github.com)

2. Claude Code が GitHub の AS に JWT Bearer Grant を実行:
     assertion = <ID-JAG>

3. GitHub AS が idpstack の JWKS で ID-JAG の署名を検証
   → access token を発行

4. Claude Code が access token で GitHub MCP Server を呼ぶ
```

JWT Bearer Grant は client 認証にも使える (`client_assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer`)。この場合、client_secret の代わりに JWT で client を認証する。

