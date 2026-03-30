# Token Exchange

[RFC 8693 OAuth 2.0 Token Exchange](https://datatracker.ietf.org/doc/html/rfc8693)

**前提**: 同一の trust domain 内 (= 同じ AS を共有するサービス群) での話。サービス A もサービス B も同じ AS (例: Idp) から token を発行してもらう。異なる AS 間 (例: Idp → GitHub) のブリッジは Token Exchange の範囲外で、それは ID-JAG の役割。

**課題**: ユーザーが BFF (Backend for Frontend) にリクエストを送る。BFF はユーザーの access token を持っている。BFF がリクエストを処理する過程で、バックエンドの analytics サービスを呼ぶ必要がある。

ここで BFF が持っている access token をそのまま analytics サービスに渡すと、以下の問題がある:

1. **scope が広すぎる**: BFF 用の access token は `scope: user.read user.write analytics.read` のように BFF が必要な全権限を持っている。analytics サービスには `analytics.read` だけ渡せば十分なのに、`user.write` まで渡ってしまう。analytics サービスが侵害された場合の影響範囲が不必要に広がる

2. **audience が違う**: BFF 用の token は `aud: bff-service` で発行されている。analytics サービスは `aud: analytics-service` の token を期待する。audience が一致しない token を受け入れると、他のサービス向けに発行された token で不正にアクセスできてしまう (token confusion attack)

3. **誰がアクセスしているか不明**: analytics サービスから見ると、受け取った token の `sub` はユーザーだが、BFF が代理しているのかユーザーが直接アクセスしているのか区別できない。監査ログに記録できない

標準 OAuth (Authorization Code, Client Credentials) にはトークンを別のトークンに変換する手段がない。BFF が analytics サービス用に scope を絞った別の token を取得する標準的な方法が存在しない。

**解決**: Token Exchange (`grant_type=urn:ietf:params:oauth:grant-type:token-exchange`) で、既存の token を入力として、AS に別の token を発行してもらう。

リクエストパラメータ:

| パラメータ             | 説明                                                   |
|------------------------|--------------------------------------------------------|
| `subject_token`        | 交換元の token。ユーザーの identity を表す             |
| `subject_token_type`   | subject_token の種類 (access_token, id_token 等)       |
| `actor_token`          | 操作を実行する主体の token (任意)。BFF 自身の token 等 |
| `actor_token_type`     | actor_token の種類                                     |
| `audience`             | 交換先の対象。どのサービス向けの token がほしいか      |
| `scope`                | 交換後の token に含めたい scope                        |
| `requested_token_type` | 欲しい token の種類                                    |

発行される token には 2 つの意味論がある:

- **Impersonation**: 新 token の `sub` は元のユーザーのみ。受信者は代理アクセスと直接アクセスを区別できない。scope だけ絞りたい場合に使う
- **Delegation**: 新 token に `sub` (ユーザー) + `act` claim (代理者) の両方が含まれる。受信者が代理者を識別できる

**具体例**: BFF → analytics サービス

前提:
- BFF と analytics サービスは同一の AS (Idp) から token を発行してもらう
- ユーザーは BFF に `scope: user.read user.write analytics.read` の access token でアクセスしている
- BFF は analytics サービスを呼ぶために、scope を絞った token がほしい

```
1. ユーザー → BFF: リクエスト (access token 付き)
   token の中身:
     sub = user-uuid-123
     aud = bff-service
     scope = "user.read user.write analytics.read"

2. BFF → AS (Idp): Token Exchange リクエスト
     grant_type = urn:ietf:params:oauth:grant-type:token-exchange
     subject_token = <ユーザーの access token>
     subject_token_type = urn:ietf:params:oauth:token-type:access_token
     actor_token = <BFF 自身の client credentials token>
     actor_token_type = urn:ietf:params:oauth:token-type:access_token
     audience = analytics-service
     scope = analytics.read

3. AS (Idp) の処理:
   a. subject_token を検証 (署名、exp、iss)
   b. actor_token を検証 (BFF は analytics サービスへの Token Exchange が許可されているか)
   c. scope の絞り込みを確認 (元の token の scope 以下であること)
   d. 新しい access token を発行:
        sub = user-uuid-123       (元のユーザー)
        aud = analytics-service   (対象サービス)
        scope = "analytics.read"  (絞り込まれた)
        act = {                   (BFF が代理していることを記録)
          "sub": "bff-client-id"
        }

4. BFF → analytics サービス: 新しい token で API 呼び出し
   analytics サービスの検証:
   - aud が自分自身 (analytics-service) であることを確認
   - scope に analytics.read が含まれることを確認
   - sub でユーザーを特定
   - act.sub で BFF 経由のアクセスであることを記録
```

**act claim のネスト**: 代理が多段になる場合、`act` claim はネストする。サービス A → サービス B → サービス C と代理が連鎖すると:

```json
{
  "sub": "user-uuid-123",
  "act": {
    "sub": "service-b",
    "act": {
      "sub": "service-a"
    }
  }
}
```

