# Memory Ordering

1つのCPUからの複数のメモリアクセスに対して順序関係を強制する仕組み。  
例えば、`req = 1`を書いてから、`info = 128`を書くプログラムがあるとする。  
`req`は制御用の変数でこれが1なら処理が依頼されており、具体的な内容は`info`に記載されるとする。  
この場合、CPU-1は`info`に値を書いたのちに、`req`に1を書き込む。  
また、CPU-2は`req`が1なのを確認してはじめて`info`の値を読む。


## Memory ordering instruction

```
load-1
store-2
store-3

<-- ordering instruction -->

load-4
load-5
store-6
```

memory barrier,やfence命令を利用すると以下の点が保証される

* load-1,store-2,store-3がinstruction以後に実行されない
* load-4,load-5,store-6がinstruction以前に実行されない

ただし、store-2とstore-3は入れ替わる場合もある。あくまでinstructionを跨がないという保証。

また、acquire, releaseは一方行のみの保証を与える。具体的には

* accquire: 後続にあるメモリアクセスが前倒しになることを禁止
  * accquireで制御変数読んでから、操作するのでこの保証でよい
* release: 先行するメモリアクセスが後ろ倒しになることを禁止
  * やることやってから、releaseで制御変数更新するので、この保証でよい

