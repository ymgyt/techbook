# clang

LLVM Compiler

* https://clang.llvm.org/docs/CommandGuide/clang.html#cmdoption-O0

## Options

* `-std` Language Standard(C標準?)の指定
  * `-std=c11`

* `-O0`,`-O1`,`-O2`: Specify which optimization level to use
  * `-O2`: moderate level of optimization(大抵のoptimizationを有効)

* `-g`: debugの出力を制御
  * `-g3`と使われているがmanualには数字について書いてない

* `-W`: enable specified warning
  * `-Wall`: すべて有効

* `-ffreestanding`: fileがfreestanding環境向けにcompileされることを指示(host/開発環境の標準libを使用しない)

* `-nostdlib`: 標準libをlinkしない


### Driver Options

* `-Wl,<args>`: comma separatedなargsをlinkerに渡す
  * `-Tkernel.ld` linker scriptにkernel.ldを使う
  * `-Map=kernel.map` mapfile(linkerの配置結果)を出力する
