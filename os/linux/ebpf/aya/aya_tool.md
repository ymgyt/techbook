# aya-tool

Cのkernel structからrustの型を生成するtool

## Install

```sh
# nixにない?
cargo install --git https://github.com/aya-rs/aya -- aya-tool

aya-tool generate sk_buff > foo-ebpf/src/vmlinux.rs
```
