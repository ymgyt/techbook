# ALPN

Application-Layer Protocol Negotiation

* TLS extentionの一つで、TLS handshake中にapplication protocolをnegotionする
  * Client Helloに対応可能なprotocolの識別子をいれる
  * Server Helloで結果を通知する
* serverがport 443でHTTP/2とHTTP/1.1両対応している場合、事前にどちらを使うか知る必要がある
  * HTTP/2の仕様で利用がMUSTとなっている
