# Asemble

## Inline asemble

clangの中にasembleを埋め込む記法。  
clangの変数とasembleを連携できる。  
registerの割当をcompileにまかせられる。

```
__asm__ __volatile__("<asembry>" : 出力operand : 入力operand : 破壊するregister)
;
```