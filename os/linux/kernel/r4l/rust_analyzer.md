# Rust Analyzer

* Cargoを利用していないので、analyzer が参照する情報を生成する必要がある

```sh
make \
   -C .build/rust-next \
   M=/home/ymgyt/rs/drivers/handson/miscdrv/module \
   LLVM=1 \
   rust-analyzer
```

* `-C` はkbuild output dir
  * そこのMakefileにsrcの情報もある
* `M=` 解析対象のroot
