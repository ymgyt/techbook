# Linker

## Mental Model

object file(`.o`)は次の情報をもっている

1. sections
  * `.text`, `.rodata`, `.data`, ...
  * 命令やデータ

2. symbol table
  * この名前の関数/変数はこのsectionのこの位置にあるという情報

3. relocation entries
  * 本物のaddressを埋めてねというTODO List


linkerがやること

* Layout
  * 複数の`.o`の`.text/.data/...`を一つのアドレス空間に並べる
  * alignも考慮

* Relocation
  * `foo`の呼び出し先は最終的に`0x400300`になったから呼び出している命令のプレースホルダーを書き換える
