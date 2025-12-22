# Backtrace

## Environment variables

* `RUST_BACKTRACE=1`: panicとerror(lib)でbacktraceが有効になる
* `RUST_LIB_BACKTRACE=1`: error(lib)だけ有効
* `RUST_BACKTRACE=1` and `RUST_LIB_BACKTRACE=0`: panicだけ有効でlibでは無効
