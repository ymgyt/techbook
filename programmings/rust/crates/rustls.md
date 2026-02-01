# rustls

## CryptoProvider

* cryptoの実装をplaggableにした。
  * そのためapplicationがどの実装を利用するか明示する必要が生じた
* 依存の関係で、provider feature(aws-lc-rs,ring)が両方有効になっているまたは全て無効だと、panicする
  * その場合, appで明示的な選択が必要
  ```rs
  rustls::crypto::ring::default_provider().install_default()
  // or
  rustls::crypto::aws_lc_rs::default_provider().install_default()
  ```

### Troubleshooting

* `cargo tree -i rustls -e features` でrutlsのfeatureを確認する
  * ring,aws-lc-rsが有効でない場合は、おそらく依存crate(tonic)等に、tls関連のflagがあるので、それを差し込む
