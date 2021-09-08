# cargo make

`Makefile.toml`を作成する。

## `Makefile.toml`

```toml
[tasks.integration]
command = "cargo"
args = ["test", "--test", "integration_test", "--",  "--nocapture"]
```
