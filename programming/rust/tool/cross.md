# cross

## install

```shell
cargo install cross
```


## build

```shell
# 本番むけには`--release`が必要。
cross build --target x86_64-unknown-linux-gnu [--release]
```

`target/x86_64-unknown-linux-gnu/`配下に成果物が生成される。
