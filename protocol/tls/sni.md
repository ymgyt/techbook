# SNI

Server Name Indication

* TLS Handshake時にClientが接続したいhostを指定するTLS Extensionの仕様
* ALBが複数domain(`foo.ymgyt.io`, `bar.ymgyt.io`)のTLSをterminationしたい場合に、http headerの送信に先立って、接続先のdomainが知りたい
  * fooとbarで証明書が違うため
  * そこで、TLS Client Hello自体にhost(domain)をのせたい


## Reference

* [Cloudflare SNIとは?](https://www.cloudflare.com/ja-jp/learning/ssl/what-is-sni/)
