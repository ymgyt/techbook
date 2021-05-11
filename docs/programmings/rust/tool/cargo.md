# Cargo

## `.cargo/config`

cargoが参照してくれる設定file。

```toml
[build]
target = "thumbv7em-none-eabihf"

[target.thumbv7em-none-eabihf]
runner = 'hf2 elf'
rustflags = [
    "-C", "lin-arg=-Tlink.x",
]
```

こうかくと`cargo build`が`cargo build --target thumbv7em-none-eabihf`となる。  
runnerを指定すると、`cargo run`実行時に、runnerをよびだしてくれる。  
`hf2 elf target/thumbv7em-none-eabihf/debug/app`がよばれる。


