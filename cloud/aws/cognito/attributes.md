# Attributes

**任意の key-value ではない。** スキーマが決まっている。

## 3種類の属性

| 種類         | プレフィックス | 例                                   | 追加方法                       |
|--------------|----------------|--------------------------------------|--------------------------------|
| 標準属性     | なし           | `email`, `name`, `picture`           | 事前定義済み (OIDC 準拠)       |
| カスタム属性 | `custom:`      | `custom:google_hd`                   | User Pool の schema で事前定義 |
| システム属性 | `cognito:`     | `cognito:groups`, `cognito:username` | **設定不可。Cognito が管理**   |

## 標準属性一覧

`sub`, `name`, `family_name`, `given_name`, `middle_name`, `nickname`, `preferred_username`, `profile`, `picture`, `website`, `gender`, `birthdate`, `zoneinfo`, `locale`, `updated_at`, `address`, `email`, `email_verified`, `phone_number`, `phone_number_verified`

## カスタム属性の制約

- Pool の schema で事前定義が必要 (`AddCustomAttributes` API)
- **定義後は削除・型変更不可** (追加のみ)
- 上限 50 個/Pool
- mutable/immutable は定義時に決定
- ID token に含まれる。access token にはデフォルトで含まれない (Pre-token Lambda で注入可)

## cognito:* claim 一覧

| Claim                    | トークン    | ソース                   | 変更方法                                           |
|--------------------------|-------------|--------------------------|----------------------------------------------------|
| `cognito:username`       | ID          | ユーザの username        | 変更不可 (immutable)                               |
| `cognito:groups`         | ID + Access | グループメンバーシップ   | `AdminAddUserToGroup` / `AdminRemoveUserFromGroup` |
| `cognito:roles`          | ID          | グループの IAM role 設定 | グループの RoleArn を変更                          |
| `cognito:preferred_role` | ID          | 最高優先度グループ       | グループの Precedence を変更                       |

`AdminUpdateUserAttributes` で `cognito:*` を直接書き換えることはできない。

## 属性のトークンへの反映

| 属性種別            | ID Token                     | Access Token               |
|---------------------|------------------------------|----------------------------|
| 標準属性 (email 等) | OIDC scope に応じて含まれる  | **デフォルトで含まれない** |
| カスタム属性        | `custom:name` として含まれる | **デフォルトで含まれない** |
| cognito:groups      | 含まれる                     | 含まれる                   |

Access token に属性を含めるには Pre-token generation Lambda (V2_0+) が必要。


## Details

* `username`
  * 識別子として機能する
  * 外部IdP由来の場合は、`MyIDP_yuta@ymgyt.io`のように固定識別子がつく
    * `<idp_id>@<idp_sub>`
  * 設定次第ではsignin時に利用される
  * 変更不可

* `sub`
  * これも識別子
  * Cognitoが自動生成?
  * 変更不可

* `email`
* `email_verified`
  * `email`が検証すみかどうか
