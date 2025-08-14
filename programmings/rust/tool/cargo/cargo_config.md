# cargo config

`.cargo/config`

cargoが参照してくれる設定file。

```toml
[build]
target = "thumbv7em-none-eabihf"

[target.thumbv7em-none-eabihf]
runner = 'hf2 elf'
rustflags = [
    "-C", "lin-arg=-Tlink.x",
]

[alias]
m = "make"
```

こうかくと`cargo build`が`cargo build --target thumbv7em-none-eabihf`となる。  
runnerを指定すると、`cargo run`実行時に、runnerをよびだしてくれる。  
`hf2 elf target/thumbv7em-none-eabihf/debug/app`がよばれる。

* `[alias]`でcargo 以降のサブコマンドのaliasを設定できる
  * `cargo m`とすると`cargo make`になる

## `[build]`

```toml
[build]
rustflags = ["-C", "force-frame-pointers=yes"]
```

* `force-frame-pointers=yes`
  * frame pointerを省略させない

* `-C`, `XXX`と`-CXXX`は同じ意味らしい

## `[net]`

```toml
[net]
git-fetch-with-cli = true
```

* `git-fetch-with-cli`: registryからのfetchに`git`を利用するかどうか
  * falseの場合はcargoのbuiltinのgitが使われる
  * trueにしたいのは、認証を`git`にまかせたいから
