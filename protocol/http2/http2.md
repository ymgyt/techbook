# HTTP/2

* TCPのASCIIでHeader/Bodyを書き込むのをやめた
* 普通のProtocolと同様にFrameの概念を導入
  * Requestを分解してFrame単位で書き込む
  * Request/Responseに対してStream IDを割り当てることで、複数リクエストを同時に書き込めるようにした
    * 一対のRequest/Responseは同じStream IDを持つ


## Frame

種別として以下がある

* DATA: PostやResponseのBody
* HEADERS: http header


## Negotiation

HTTP/1.1を期待している443(のうしろの80等)のServer(process/プログラム)にいきなりHTTP/2のFrameを送れない
そのため、なんらかの手段でclient server間でHTTP/2を使うことの合意が必要

* ALPN
  * TLS拡張なので443の場合

* HTTP upgrade
  * HTTP/1.1のprotocolでupgradeする(WebSocketと同じ)

  client
  ```text
  GET / HTTP/1.1
  Host: server.example.com
  Connection: Upgrade, HTTP2-Settings
  Upgrade: h2c
  HTTP2-Settings: <paylaod...>
  ```

  server
  ```text
  HTTP/1.1 101 Switching Protocols
  Connection: Upgrade
  Upgrade: h2c
  ```

* いきなりHTTP/2を使う(Prior knowledge)
  * ClientはTCP接続後に、Connection Preface?を送る
  * `PRI * HTTP/2.0\r\n\r\nSM\r\n\r\n`


## Server Push

* Serverがclientがほしいであろうデータをrequestなしで送ること
  * clientとの接続がある前提

## References

[Introduction to HTTP/2](https://developers.google.com/web/fundamentals/performance/http2/)
