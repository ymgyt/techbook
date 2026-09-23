# GCC

## 参考

* [GCC Runebook.dev](https://runebook.dev/ja/docs/gcc/-index-)

## Options

### `-W` 下位ツールへoptionを渡す

* `-W<x>,<options...>` xで下位ツールを指定
  * `-Wa,` assembler
  * `-Wp,` preprocessor
  * `-Wl,` linker
    * `-Wl,--gc-sections` linkerに`--gc-sections` を渡す

