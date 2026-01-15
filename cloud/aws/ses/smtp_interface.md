# SMTP Interface

SESをSMTP Serverとして利用する場合

## SMTPでメールを送るまでの流れ

1. IAM Userを作成

  ```hcl
  data "aws_ses_domain_identity" "my_domain" {
    domain = "ymgyt.io"
  }
  resource "aws_iam_user" "smtp_user" {
    name = "SmtpUser"
    path = "/"
  }

  resource "aws_iam_user_policy" "example" {
    name = "send-mail-via-ses"
    user = aws_iam_user.smtp_user.name
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = "ses:SendRawEmail"
          Resource = [
            data.aws_ses_domain_identity.my_domain.arn,
          ]
        }
      ]
    })
  }
  ```

2. IAM UserにAccessKeyを作成

  ```sh
  aws iam create-access-key --user-name SmtpUser
  ```

  * `AccessKey.AccessKeyId`がUsername
  * `AccessKey.SecretAccessKey`を加工したものがpassword

3. AccessKey CredentialからSMTP Credential(Username/Password)を生成

  ```nu
  export def ses_smtp_password [
    region: string,
    secret_access_key: string
  ]  {
    # これは仕様で固定値
    let date = "11111111";
    let service = "ses";
    let terminal = "aws4_request";
    let message = "SendRawEmail";
    let version_hex = "04"

    let k_date = (hmac_sha256_hex (str_to_hex $"AWS4($secret_access_key)") $date)
    let k_region = (hmac_sha256_hex $k_date $region)
    let k_service = (hmac_sha256_hex $k_region $service)
    let k_terminal = (hmac_sha256_hex $k_service $terminal)
    let k_message = (hmac_sha256_hex $k_terminal $message)

    let smtp_password = ($version_hex + $k_message) | decode hex | encode base64

    $smtp_password
  }

  def hmac_sha256_hex [hexkey: string, msg: string] {
    ($msg | ^openssl dgst -sha256 -mac HMAC -macopt $"hexkey:($hexkey)")
    | str trim
    | parse -r '(?P<hex>[0-9a-f]{64})$'
    | get 0.hex
  }

  def str_to_hex [s: string] {
    $s | encode utf-8 | encode hex
  }
  ```

4. SMTP Protocolで利用

  ```nu
  #!/usr/bin/env nu

  use std/log [info]
  use lib/aws/ses.nu [ses_smtp_password]

  # SESのテストメールを送信する
  # SMTP Credential用のIAM UserのCredentialを必要とする
  # SES_ACCESS_KEY_ID=xxx SES_SECRET_ACCESS_KEY=yyy ./send-test-mail.nu
  def main [
    to: string,
    --from: string = "noreply@akeg.me"
    --subject: string = "SES SMTP test"
    --body: string = "test"
    --dry-run # 実際にメールを送らない
  ] {
    let cred = load_ses_env
    if ($cred.access_key_id | is-empty) or ($cred.secret_access_key | is-empty) {
      error make { msg: "environment variables SES_ACCESS_KEY_ID and SES_SECRET_ACCESS_KEY required"}
    }

    let region = "ap-northeast-1"
    let smtp_endpoint = $"email-smtp.($region).amazonaws.com"
    let port = 465;
    let user = $cred.access_key_id;
    let password = (ses_smtp_password $region $cred.secret_access_key)
    let auth = "LOGIN"

    let subject = $"Subject: ($subject)";

    let maybe_dump = if $dry_run { ["--dump"] } else { [] }

    (swaks
      --to $to
      --from $from
      --server $smtp_endpoint
      --port $port
      --tls-on-connect
      --auth $auth
      --auth-user $user
      --auth-password $password
      --header $subject
      --body $body
      ...$maybe_dump
    )
  }

  def load_ses_env [] {
    {
      access_key_id: $env.SES_ACCESS_KEY_ID?,
      secret_access_key: $env.SES_SECRET_ACCESS_KEY?
    }
  }
  ```
