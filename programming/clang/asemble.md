# Asemble

## Inline asemble

clangの中にasembleを埋め込む記法。  
clangの変数とasembleを連携できる。  
registerの割当をcompileにまかせられる。

* Cの仕様ではなく独自拡張機能
* https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html

```
__asm__ __volatile__("<asembry>" : 出力operand : 入力operand : 破壊するregister)
;
```

* 出力operand
  * asembleの処理結果をどこに取り出すかの宣言
  * "制約" (Cの変数名)
    * `=`はasemblyで変更されること
    * `r`はいずれかの汎用registerを利用すること

* 入力operant
  * asebleで使いたい値を宣言
  * "制約"(Cの式)
    * `r` いずれかの汎用regiterを利用

* 破壊するregister
  * 指定すると内容が保存、復元される

* operandは`0%`,`1%`と順番にasembleから参照できる

* `__volatile__`は最適化しないことをcompilerに指示する


### 具体例

```c
uint32_t value;
__asm__ __volatile__("csrr %0, spec" : "=r"(value));
```

csrr命令でspec registerを読み出して、value変数に代入する。  
`%0`がvalue変数に対応

```c
__asm__ __volatile__("csrw sscratch, %0" : : "r"(123));
```
は以下に展開される

```
li a0, 123
csrw sscratch, a0
```

csrw命令で、sscratch registerに123を書き込む


