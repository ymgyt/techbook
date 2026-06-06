# Miri

RustのMid level intermediate representation(MIR)をparseするtool

## Usage

```sh
rustup +nightly component add miri
```

```sh
cargo clean

cargo +nightly miri test
cargo +nightly miri run
```

* cargo run/testと同じflagが利用できる
