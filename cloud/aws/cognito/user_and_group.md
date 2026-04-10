# User and Group

## Users

ローカルユーザとフェデレーションユーザの2種類。

| フィールド   | 説明                                                           |
|--------------|----------------------------------------------------------------|
| `sub`        | UUID。immutable。トークンの `sub` claim                        |
| `username`   | immutable。フェデレーションユーザは `Google_<google_sub>` 形式 |
| `UserStatus` | `CONFIRMED`, `FORCE_CHANGE_PASSWORD`, `EXTERNAL_PROVIDER` 等   |
| `Enabled`    | boolean                                                        |
| `Attributes` | standard + custom 属性 (後述)                                  |
| `identities` | リンク済み外部 IdP の配列 (read-only)                          |

### ローカルユーザ vs フェデレーションユーザ

|            | ローカル                                | フェデレーション                      |
|------------|-----------------------------------------|---------------------------------------|
| 作成方法   | `AdminCreateUser` or セルフサインアップ | 外部 IdP 経由の初回ログインで自動作成 |
| username   | 任意 or メール                          | `ProviderName_providerUserId`         |
| パスワード | あり                                    | なし (`EXTERNAL_PROVIDER` 状態)       |
| 認証方法   | PASSWORD / EMAIL_OTP                    | Hosted UI 経由で外部 IdP              |
| API 認証   | `InitiateAuth` / `AdminInitiateAuth` 可 | **不可** (Hosted UI のみ)             |
| Status     | `CONFIRMED` (パスワード設定後)          | `EXTERNAL_PROVIDER`                   |

### ユーザリンク (AdminLinkProviderForUser)

フェデレーション ID を既存のローカルユーザに事前紐付けする仕組み。

```
ローカルユーザ user@example.com を作成
  → AdminLinkProviderForUser で Google ID をリンク
  → ユーザが Google でログインすると既存プロファイルに統合
  → 別プロファイルが自動作成されない
```

- 1ユーザに最大5つの IdP をリンク可能
- 複数の認証手段を1つのプロファイルに統合するために使う

## Groups

| フィールド    | 説明                                                |
|---------------|-----------------------------------------------------|
| `GroupName`   | Pool 内で一意                                       |
| `Description` | 任意                                                |
| `Precedence`  | 数値。小さいほど優先度高                            |
| `RoleArn`     | IAM role (Identity Pool 用。OAuth scope とは無関係) |

- ネストなし (フラット構造)
- Cognito は IdP ごとに自動生成グループも作る (`<user_pool_id>_<provider_name>`)
- **Group に OAuth scope を紐付ける機能はない** → Pre-token Lambda が必要

### Group とトークン

| Claim                    | トークン    | 内容                          |
|--------------------------|-------------|-------------------------------|
| `cognito:groups`         | ID + Access | 所属グループ名の配列          |
| `cognito:roles`          | ID          | グループの IAM role ARN 配列  |
| `cognito:preferred_role` | ID          | 最高優先度グループの IAM role |
