# DMARC

Domain-based Message Authentication, Reporting, and Conformance

* (SPF, DKIM)のauthentication testに失敗したメールをどうするか決めるもの
* Policy言語

## 受信SMTP Serverがもっている情報

* 接続元IP
* MAIL FROM(Envelop From)
* From Header
* DKIM-Signature
* DNS 情報
  * SPF Record
  * DKIM 公開鍵
  * DMARC Policy

