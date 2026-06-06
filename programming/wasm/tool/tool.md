# WASM Tools 

## wat2wasm

```sh
# debug情報(custom section)を付与
wat2wasm hello.wat --debug-names
```

## wasm3

```sh
# Run wasm interpreter
wasm3 --repl ./hello.wasm

# Call exported function
wasm3> exported_foo

# Ctrl-C to quit
```

## wasm-objdump

```sh
# moduleのsectionを表示
wasm-objdump -x hello.wasm
```