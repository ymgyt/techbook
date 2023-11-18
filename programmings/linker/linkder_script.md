# Linker Script

## Memo

```text
ENTRY(boot)

SECTIONS {
    . = 0x80200000;

    .text :{
        KEEP(*(.text.boot));
        *(.text .text.*);
    }

    .rodata : ALIGN(4) {
        *(.rodata .rodata.*);
    }

    .data : ALIGN(4) {
        *(.data .data.*);
    }

    .bss : ALIGN(4) {
        __bss = .;
        *(.bss .bss.* .sbss .sbss.*);
        __bss_end = .;
    }

    . = ALIGN(4);
    . += 128 * 1024; /* 128KB */
    __stack_top = .;
}
```

* `ENTRY(boot)`: (kernelの)entryはboot関数

### Section

* `.text` code(実行命令)
* `.rodata` 定数の読み取り専用
* `.data` 読み書き可能
* `.bss` 読み書き可能　`.data`との違いは初期値がzero

* `.`は現在のaddressを表す
  * `*(.text)`等でデータが配置されるたびに自動で加算される
  * `. += 128 * 1024`は現在アドレスから128KB進めると読む

* `ALIGN(4)`は4byteにalignmentする

* `*(.text .text.*)`は全file(`*`)の`.text`と`.text.`ではじまるsectionをそこに配置する
  * `KEEP(*(.text.boot))`で`.text.boot`が先頭(宣言された位置)にくる

* `__bss = .`は`__bss`というシンボルに現在のアドレスを割り当てる
  * Cでは、`extern char __bss`で参照できる
