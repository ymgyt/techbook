# ELF

* `man 5 elf`
* linkerによって作成され、loaderによって読まれる
* ELF header, section header, program header(segment)の３つのheaderからなる
* kernel `include/uapi/linux/elf.h`に定義がある

## Memo

* sectionはlinkの単位
  * link時に各object fileにはsectionがある
  * linkerはELFにこれをまとめる?
* segmentは実行時(load)の単位
  * linkerがloaderのために作成する


## Sections

* linkerのための情報。kernelはみない
  * `.text`: 機械語
  * `.data`: 初期値のある変数
  * `.bss`: Block started by symbol
    * 初期値が未定義な変数
    * ELFにはsize情報だけ
    * 実行時にメモリにロードされるときにメモリを確保する?
  * `.rodata`
  * `.dynsym`
  * `.strtab`

## Segments(Program Header)

* ELF的にはprogram header
* 複数のsectionをまとめたもの
  * `.text`,`.rodata`,`.eh_frame` をまとめてRX
  * `.data`,`.got`,`bss` はRW
* mmapの単位
  * 仮想メモリのページ用の属性を保持

```c
// このheader がarrayになってる
typedef struct elf64_phdr {
  Elf64_Word p_type;
  Elf64_Word p_flags;
  // ELFからのoffset
  Elf64_Off p_offset;		/* Segment file offset */
  Elf64_Addr p_vaddr;		/* Segment virtual address */
  Elf64_Addr p_paddr;		/* Segment physical address */
  Elf64_Xword p_filesz;		/* Segment size in file */
  Elf64_Xword p_memsz;		/* Segment size in memory */
  Elf64_Xword p_align;		/* Segment alignment, file & memory */
} Elf64_Phdr;
```

### PT_INTERP

動的linkerの指定

```sh
# Interpreter filedのoffsetとsizeを取得
readelf -l hello | rg 'INTERP|Type'
  Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
  INTERP         0x000318 0x0000000000000318 0x0000000000000318 0x000053 0x000053 R   0x1

# 0x318 から0x53を表示
# /nix/store/xxx-ld-linux-x86-64.so だとわかる
hexyl -s 0x318 ./hello -n 0x53
┌────────┬─────────────────────────┬─────────────────────────┬────────┬────────┐
│00000318│ 2f 6e 69 78 2f 73 74 6f ┊ 72 65 2f 6a 31 39 33 6d │/nix/sto┊re/j193m│
│00000328│ 66 69 30 66 39 32 31 79 ┊ 30 6b 66 73 38 76 6a 63 │fi0f921y┊0kfs8vjc│
│00000338│ 31 7a 6e 6e 72 34 35 69 ┊ 73 70 76 2d 67 6c 69 62 │1znnr45i┊spv-glib│
│00000348│ 63 2d 32 2e 34 30 2d 36 ┊ 36 2f 6c 69 62 2f 6c 64 │c-2.40-6┊6/lib/ld│
│00000358│ 2d 6c 69 6e 75 78 2d 78 ┊ 38 36 2d 36 34 2e 73 6f │-linux-x┊86-64.so│
│00000368│ 2e 32 00                ┊                         │.2⋄     ┊        │
└────────┴─────────────────────────┴─────────────────────────┴────────┴────────┘
```

## Reference

* [ELFのオブジェクトファイル形式を生成する](https://tyfkda.github.io/blog/2020/04/20/elf-obj.html)
