# WASM

## memo

I/Oやsystemcallといった外部リソースの利用は、`embedder`から提供される`functions`を通して行われる。

## Tools

### `wasm-pack`

#### install 

`curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh`

## 環境構築

```console
# enable wasm features
rustup target add wasm32-unknown-unknown

# build
cargo build --target=wasm32-unknown-unknown --release
```

### `Cargo.toml`

wasmではRust用のmetadataが不要なので以下を指定する。  
https://github.com/rust-lang/rfcs/blob/master/text/1510-cdylib.md
```toml
[lib]
crate-type = ["cdylib"]
```

### `lib.rs`
`#[no_mangle]`を指定することで、jsから`add`で呼べるようにしている。

```rust
#[no_mangle]
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

extern {
    fn date_now() -> f64;
}

#[no_mangle]
pub fn get_timestamp() -> f64 {
    unsafe {
        date_now()
    }
}
```

### `<script>`

```html
<!DOCTYPE>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Hello, WASM!</title>
  <script>
    // 追加
    const imports = {
      env: {
        date_now: Date.now,
      },
    }
    const wasm =
        './target/wasm32-unknown-unknown/release/wasm_dev_book_hello_wasm.wasm'
    fetch(wasm)
        .then((response) => response.arrayBuffer())
        // `WebAssembly.instantiate` の引数に `imports` を追加
        .then((bytes) => WebAssembly.instantiate(bytes, imports))
        .then((results) => {
          const { add, get_timestamp,now } = results.instance.exports
          console.log(add(1, 2))
          // 追加
          console.log(get_timestamp())
        })
  </script>
</head>

</html>
```
