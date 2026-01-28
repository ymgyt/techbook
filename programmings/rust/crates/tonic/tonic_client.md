# tonic client

## Types

* `Endpoint`: 接続の設定を記述するstruct
  * 接続先URI, TLS
  * timeout,keepalive
  * http2関連

* `Connector`: `Endpoint`を使ってsocketを張る君

* `Channel`: HTTP/2のconnection(handle?)

* `Client`: protobufから生成されたRPCスタブ
  * requestをframingしてchannelに流す

* `Interceptor`: ClientとChannelの間に介在して処理を注入するmiddleware

## Client construction

```
URI
-> Endpoint (接続設定) connect()
-> Channel (HTTP2 transport)
-> Client<ChanneL>
-> Client<Interceptor<Channel>>
```
