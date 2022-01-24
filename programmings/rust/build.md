# build

## target triples

* `machine-vendor-os`のformatをとる
  * machine
    * `x86_64`,`armv7`,`wasm32`
    * compilerにinstruction setをつたえる
  * vendor
    * `apple`,`windows`,`unknown`
    * compilationに対してno effectらしい
    * `#[cfg(...)]`の設定はここ?
  * os
    * ABIをつたえる
    * `.so`や`.dll`はここで決まる


