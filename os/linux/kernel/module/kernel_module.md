# Kernel Module

* 一定の構造をもつobject file

## `THIS_MODULE`

* `.ko` をkernelが管理するための`struct module` への参照

kernelはmoduleについて概ね以下を管理している

* module name
* メモリ範囲
* `init`, `exit` 関数
* moduleの依存関係
* `/sys/module`
* symbol

これらを`struct module` で管理している

`include/linux/init.h`

```c
#ifdef MODULE
extern struct module __this_module;
#define THIS_MODULE (&__this_module)
#else
#define THIS_MODULE ((struct module *)0)
#endif
```

`THIS_MODULE` は `struct module`へのpointer

## Build

いろいろ生成されるので整理する。`foo` moduleとする。

* `foo.mod`
  * moduleを構成する`.o` 一覧
* `foo.mod.c`
  * modpostが生成したmodule管理情報C code
* `foo.mod.o`
  * `foo.mod.c`をcompileしたELF

最終的には`foo.ko` = `foo.o` + `foo.mod.o`

## Commands

```sh
# memoryにあるmodule一覧
lsmod
```
