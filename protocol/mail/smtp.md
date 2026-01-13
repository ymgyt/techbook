# SMTP

Simple Mail Transfer Protocol
[RFC5321](https://datatracker.ietf.org/doc/html/rfc5321)

## Flow

1. email clientがoutgoing SMTP serverに接続する(defaultではport: 587,465)
2. SMTP Authでclientを認証する
  * username/password
3. 送ろうとしているemailをvalidateする
4. 送信先mail serverをDNSでlookupする(MX record)
5. outgoing SMTP <-> 送信先SMTPで通信
  * HELO/EHLO
  * MAIL FROM
  * RCPT TO
  * DATA
6. 送信先SMTPが各種検証を行う
  * SPF, DKIM, DMARC
7. 送信が完了する

```sh
HELO ymgyt.io
250 mail.example.com

# Envelope From
MAIL FROM: me@ymgyt.io
250 2.1.0 OK

# Envelope To
RCPT TO: foo@example.com
250 2.1.5 OK

# 本文を送る
DATA
354 End data with <CR><LF>.<CR><LF>
From: me@ymgyt.io
To: foo@example.com
Subject: Hello
Test mail body here.
.
250 2.0.0 OK: queued as 123456

# Close
QUIT
221 2.0.0 Bye
```


## TLS

* Protocolは平文前提なのでどこかでTLSにする

### STARTTLS

* 平文で接続したのち、認証情報を送る前に`STARTLS`コマンドを送る
* portは`587`


### SMTPS

* SMTPの前にTLS接続する
* SMTPのプロトコルは最初からTLS内で行われる
* portは`465`


## SMTPにおけるSenderとは

* `MAIL FROM`: Envelop from
  * 送信先が存在しない場合にエラーメールの送信先に使われる
  * Return-Path とも
  * BCCの場合等、Header Fromとは一致しない場合もある
* `From:`: Header from
  * SMTPからみるとただのpayload.
  * 人間が見る送信者
