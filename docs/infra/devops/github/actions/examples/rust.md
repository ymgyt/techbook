# Rust Actions

## use cargo make

CIでもcargo makeをtask runnerとして利用する。

```yaml
steps:
# checkoutしないとMakefileが見えない
- uses: actions/checkout@v2
  - 
# cargo install cargo-makeするより速い
- uses: davidB/rust-cargo-make@v1

# cargoを別にいれなくても実行できる
- name: Run hello
  run: cargo make my_task
```
