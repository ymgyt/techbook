# Rust for Linux

* [Contact](https://rust-for-linux.com/contact)

## Kernel Config

* `CONFIG_RUST=y`
* `CONFIG_SAMPLES=y`
* `CONFIG_SAMPLES_RUST=y`

### menuconfig

* `General setup` -> `Rust support`
* `Samples` -> `Rust samples`

## Mailing list

* `rust-for-linux@vger.kernel.org`
  * `	rust-for-linux+subscribe@vger.kernel.org`にメールを送る
  * digest購読後に送るとこちらの購読モードに遷移した
* digest版
  * `rust-for-linux+subscribe-digest@vger.kernel.org` にsubscribeしたいアドレスからメールを送る
  * digest版らしい


## Memo

* rustc_codegen_gcc はLLVMの代替
  * compiler front,middleは同じでbackendをLLVM非違依存にする
  * gccrustはC++でrustcを実装する試みで別

