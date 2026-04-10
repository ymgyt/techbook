# Lambda Trigger

* Cognitoの各hook pointにlambdaを差し込める機能
* Trigger type
  * Pre token generation

* Trigger point と version は別の概念。
  * Trigger point: User Pool のどのイベントで Lambda を呼ぶか
  * Version: trigger point に渡されるイベントペイロードの形式
    * version があるのは一部の trigger point のみ

* 各 trigger point には Lambda を 1つだけ 設定可能。
  * ただし同じ Lambda を複数の trigger point に設定することはできる (`event.triggerSource` で分岐)。


## Trigger Types

### 認証系

| Trigger             | Terraform 属性        | タイミング                | 具体的な用途                                                                                                         |
|---------------------|-----------------------|---------------------------|----------------------------------------------------------------------------------------------------------------------|
| Pre sign-up         | `pre_sign_up`         | サインアップ前 (確認前)   | 特定ドメインのメールのみ許可、属性バリデーション、auto-confirm/auto-verify                                           |
| Pre authentication  | `pre_authentication`  | 認証前 (パスワード検証後) | IP ベースのサインイン拒否、カスタム rate limit、監査ログ                                                             |
| Post authentication | `post_authentication` | 認証成功後                | **Google ユーザのグループ自動割り当て** (`custom:xxx` を見て group に追加)、ログイン履歴記録、外部システム通知 |
| Post confirmation   | `post_confirmation`   | ユーザ確認完了後          | ウェルカムメール送信、外部 DB にユーザレコード作成、Slack 通知                                                       |

### カスタム認証チャレンジ

| Trigger               | Terraform 属性                   | タイミング                            | 具体的な用途                                                |
|-----------------------|----------------------------------|---------------------------------------|-------------------------------------------------------------|
| Define auth challenge | `define_auth_challenge`          | カスタム認証フロー開始時              | 次のチャレンジを決定 (TOTP → SMS → 成功/失敗の分岐ロジック) |
| Create auth challenge | `create_auth_challenge`          | Define が CUSTOM_CHALLENGE を返した後 | チャレンジパラメータ生成 (OTP コード生成、CAPTCHA 画像生成) |
| Verify auth challenge | `verify_auth_challenge_response` | ユーザがチャレンジに応答した後        | 回答の正誤判定 (OTP コード照合)                             |

3つセットで使用。標準認証 (PASSWORD, EMAIL_OTP) で十分なら不要。

### トークン

| Trigger                       | Terraform 属性                | Version            | 具体的な用途                                      |
|-------------------------------|-------------------------------|--------------------|---------------------------------------------------|
| Pre token generation          | `pre_token_generation`        | V1_0 のみ          | ID token の claims カスタマイズのみ。レガシー     |
| Pre token generation (config) | `pre_token_generation_config` | V1_0 / V2_0 / V3_0 | **access token の scope 注入**、claims 追加。後述 |

`pre_token_generation` と `pre_token_generation_config` は **排他** (どちらか片方のみ)。

### メッセージ

| Trigger             | Terraform 属性        | タイミング                          | 具体的な用途                                              |
|---------------------|-----------------------|-------------------------------------|-----------------------------------------------------------|
| Custom message      | `custom_message`      | 検証/確認/MFA メッセージ送信前      | メール/SMS の文面カスタマイズ (HTML メール化、多言語対応) |
| Custom email sender | `custom_email_sender` | メール送信時 (デフォルト送信の代替) | SES 等の独自メール送信。KMS key 必須                      |
| Custom SMS sender   | `custom_sms_sender`   | SMS 送信時 (デフォルト送信の代替)   | 独自 SMS プロバイダ経由の送信。KMS key 必須               |

### マイグレーション

| Trigger        | Terraform 属性   | タイミング                                      | 具体的な用途                             |
|----------------|------------------|-------------------------------------------------|------------------------------------------|
| User migration | `user_migration` | 存在しないユーザのログイン/パスワードリセット時 | レガシーの認証基盤からのオンデマンド移行 |
