# Dynamic Segment

* `PT_DYNAMIC`
* `Elf64_Dyn` の配列
  * tag(enum) value 形式


## `Elf64_Rela`

relocation 1件を表すデータ構造

```c
typedef struct {
    Elf64_Addr   r_offset;
    Elf64_Xword  r_info;
    Elf64_Sxword r_addend;
} Elf64_Rela;
```

* `r_offset` relocationを適用するELF vaddress
  * 実際に書き換える位置はbase + `r_info`

* `r_info`
  * symbol indexとrelocation typeを保持

* `r_addend`
  * relocationに利用する加算値A

## `DT_RELA`

* relocation tableのaddress
  * `.rela.dyn` に対応？
* `DT_RELASZ` でtable sizeを取得

## `DT_JUMPREL`

* PLTに関連する relocation tableのaddressを格納
* reloation tableの長さは `DT_PLTRELSZ`で取得

* Section headerからは`.rela.plt` として参照できる。同じものをみている
