# Twingate

## Memo

* Client(ユーザ) と connector がTLSをはる
  * connector はCloudやオンプレにinstallする
  * connector からoutboundで接続をはる?

* Client(userがdeviceにinstallする) は`nas.home.internal` のような、private DNS を外から解決できる
  * clientがdns request をintercept して、connector に渡して、connector がprivate network 内のdns resolverに問い合わせる

  * userが許可されている、FQDNとIPのlistをもっている
    * `nas.home.ini` がのっている場合、そのリクエストをinterceptする

  * Client はuserのdns resolverの設定を書き換える
    * `nas.home.ini` は `100.108.192.142` に解決される
      * CGNAT `100.64.0.0/10` でpublic IPだけど、一般userには提供されないというIP Range

  * Client は userのdeviceにnetwork interface cardを追加する
    * CGNAT 行きのpackageはこのICに渡される

  * Client からなんらかの方法で、connectorに渡される
    * connector は`nas.home.ini` をprivateのdnsで解決して、resourceにroutingする


### Client と Connectorの接続

1. Client, Connector は Relayに接続する
  * Relayはglobalからアクセスできる
  * 認証もする
  * これにより、NAT越しのPublicIPとportがわかる

2. ClientとConnectorは同時に互いにpacketを送る
  * inboundがblockされているfirewallでも、outboundのresponseは許可する(そうしないと通信できない)
  * ClientはConnectorのNATにpacketを送っている(outbound)ので、Connecotrからのpacketを受け取れる
  * ConnectorはClientのNATにpacketを送っているので、Clientからのpacketを受け取れる
