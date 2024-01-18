# Rust Actions

## Rust toolchainのintall

```yaml
jobs:
  test:
    name: cargo test
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - uses: dtolnay/rust-toolchain@stable
      components: "clippy,rustfmt"
    - run: cargo test --all-features
```

* `dtolnay/rust-toolchain`を使う
  * `@stable`と書くと、引数の`toolchain`のdefault値がstableになっている
  * `uses: dtolnay/rust-toolchain@1.75.0`のようにversionも指定できる
    * ただしwithでtoolchainを指定すると意図通りに動かないらしい?

## cache

TODO: rust-cache

## install tools

TODO: taiki install-action

## use cargo make

CIでもcargo makeをtask runnerとして利用する。

```yaml
steps:
# checkoutしないとMakefileが見えない
- uses: actions/checkout@v2

# rustc,cargoといったtoolchainのinstall
- uses: actions-rs/toolchain@v1
  with:
    toolchain: stable
    components: rustfmt, clippy

# cargo install cargo-makeするより速い
- uses: davidB/rust-cargo-make@v1

# cargoを別にいれなくても実行できる
- name: Run hello
  run: cargo make my_task
```

## Integration

```yaml
on:
  push:
    branches: [main]

name: Integration

jobs:
  lint:
    name: Lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions-rs/toolchain@v1
        with:
          toolchain: stable
          components: rustfmt, clippy
      - uses: davidB/rust-cargo-make@v1
      - name: Lint
        run: cargo make lint
  test:
    name: Test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions-rs/toolchain@v1
        with:
          toolchain: stable
      - name: Install nextest
        shell: bash
        run: |
          curl -LsSf https://get.nexte.st/latest/linux | tar zxf - -C ${CARGO_HOME:-~/.cargo}/bin
      - uses: davidB/rust-cargo-make@v1
      - name: Run Test
        run: cargo make test
        env:
          NEXTEST_PROFILE: ci
```

## Release

```yaml
on:
  push:
    tags:
      - 'v*.*.*'

name: Delivery

jobs:
  create-release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: taiki-e/create-gh-release-action@v1
        with:
          # releaseする際のtagがv0.1.2だとしたら
          # CHANGELOGに[0.1.2]のsectionがないとエラーになる
          changelog: CHANGELOG.md
          title: $tag
          draft: false
          branch: main
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  upload-assets:
    strategy:
      matrix:
        os:
          - ubuntu-latest
          - macos-latest
          - windows-latest
    runs-on: ${{matrix.os }}
    steps:
      - uses: actions/checkout@v3
      - uses: taiki-e/upload-rust-binary-action@v1
        with:
          # buildするbinary名
          bin: clc
          # linux,macがtarになる
          tar: unix
          zip: windows
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  publish-cratesio:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions-rs/toolchain@v1
        with:
          toolchain: stable
          # cargo is enough
          profile: minimal
      - name: Setup local credential
        run: cargo login ${CRATES_IO_TOKEN}
        env:
          # 事前にcrates.ioでapi tokenを発行しておく必要がある
          CRATES_IO_TOKEN: ${{ secrets.CRATES_IO_TOKEN }}
      - name: Publish package
        run: cargo publish --package clc
```

* gitのtagをpushするとGithub Releaseが作成される
