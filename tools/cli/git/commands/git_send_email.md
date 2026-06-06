# git send-email

## Usage

```nushell
let to = "me@example.com"
# dry-run
git send-email --dry-run --to $to out/*.patch

# kernel patch
git send-email \
  --to $to \
  --annotate \
  --thread \
  --no-chain-reply-to \
  --confirm=always \
  /tmp/patch
```

## Configuration

```text
# gmailの場合
[sendemail]
    smtpEncryption = "tls"
    smtpServer = "smtp.gmail.com"
    smtpServerPort = 587
    smtpUser = "foo@gmail.com"
```
