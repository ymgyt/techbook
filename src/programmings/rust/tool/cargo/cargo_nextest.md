# cargo-nextest

## Install

```shell
cargo install cargo-nextest

# linux
curl -LsSF https://get.nexte.st/latest/linux | tar zxf - -C ${CARGO_HOME:-~/.cargo}/bin

# mac
curl -LsSf https://get.nexte.st/latest/mac | tar zxf - -C ${CARGO_HOME:-~/.cargo}/bin
```


## Config

### Profile

```yaml
[profile.ci]
# Print out output for failing tests as soon as they fail, and also at the end
# of the run (for easy scrollability).
failure-output = "immediate-final"
# Do not cancel the test run on the first failure.
fail-fast = false
```

* `cargo nextest run --profile ci`
