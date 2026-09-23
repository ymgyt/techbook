# Symbol

section `.symtab` に`Elf64_Sym` の配列として格納される


## Bind

当該symbolを他のELFから参照できるかとうか
`st_info` 上位4bit

* local
  * 当該ELFだけで参照できる
* Global
  * 他ELFから同名symbolで解決できる
* Weak
  * 同名のGlobalがあれば負ける

## Type

`st_info` 下位4bit

* None: 指定なし
* Object: 変数、配列
* Func: 関数
* Section: section

## `st_name`

文字列テーブル(`strtab`)からのoffset


## `shndx`

当該symbolが属するsectionのsection headerのindex
`SHN_UNDEF = 0` の場合は当該ELFでは未定義

## `st_value`

link前は`shndx`が表すsectionからのoffset

link後は仮想アドレス


## `st_size`

当該symbolが占めるbyte数
