# Virtual Address

仮想記憶について。  
仮想アドレスと物理アドレスの対応付けはページ単位でなされる。  
つまり、ページサイズの分だけ下位アドレスを無視することになる。  
対応づけを保持するデータ構造をページテーブルという。

* CPU cacheは物理アドレス変換後のものをkeyにする

```rust
let mut page_table = vec![0_usize; num_of_page];  

let page_addr = page_table[vir_addr / 4096] + (vir_addr % 4096);
```

* 一番naiveな実装だと、virtual addressをpage sizeで割って、余りをたすことで物理addressに変換する


## メリット

* 不連続な物理アドレスを連続な仮想アドレスとして見せることができる
* プロセスを起動ごとに異なる物理アドレスに配置できる
* 仮想アドレスにおいて0番地から始まる複数のプロセスを保持できる
* メモリに保持できない分をSSD等に逃がせる


## TLB

CPU側に記載。

