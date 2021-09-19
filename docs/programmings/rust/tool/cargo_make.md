# cargo make

`Makefile.toml`を作成する。

## `Makefile.toml`

```toml
[tasks.integration]
command = "cargo"
args = ["test", "--test", "integration_test", "--",  "--nocapture"]

[tasks.init]
dependencies = [
    "cargo_install",
    "add_wasm_target"
]

[tasks.cargo_install]
command = "cargo"
args = ["install", "trunk", "wasm-bindgen-cli"]

[tasks.add_wasm_target]
command = "rustup"
args = ["target","add", "wasm32-unknown-unknown"]
```
