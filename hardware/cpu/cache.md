# Cache

メモリの一部をコピーしてCPUの近くに配置する仕組み。  

* 命令cacheとdata cacheがある
* メモリアドレスをkey, 対応する値をvalueとするtableというデータ構造
  * 値には該当アドレスから複数アドレスを保持する。これはcache lineという。
    * spatial locality(空間局所性)を利用している
    * 64byteがarm,x86では一般的


## 実装方式

### Full associative

アドレス全体をkeyにする。したがって、任意位置にentryを保持できる。


### Set associative

アドレスの一部をテーブルentryのindexに対応づけるという制約をもつ。  
例えばアドレスの下位1byteを indexに対応づける等。こうするとアドレスを見ただけでindexがわかるので検索が高速になる。  

cacheの検索はCPUの1サイクル以内に行う必要があるので採用される。  
ただし、この制約により異なるアドレスであってもindexが衝突することとなる。

#### Way数

そこで、テーブルを多重化し、同一indexに複数のアドレスと値を保持できるようにする。  
1つのindexに記録できるentry数をwayといったりする。(連想度, associativityとも)


## TLB

Translation Lookaside Buffer

メモリにアクセスする際に毎回、仮想アドレスを物理アドレスに解決していては遅い。 物理アドレスにアクセスするためにメモリ上のページテーブルを複数回参照する必要がある。
そこで、メモリ上のページテーブルの一部をコピーして保持するhardwareがCPU上にあり、これをTLB (Translation Lookaside Buffer)という。


## Coherence

CPUごとにcacheを保持しているので、同一アドレスのコピーが複数cacheに存在することになる。  
その結果、CPU-1で書き込んだ値がCPU-2から読めないという状況が生じてしまう。  
そこで、CPUが書き込んだ値を他のCPUに適切に伝える仕組みが必要になる。これがCache coherence。  

Coherenceとは、**同一アドレスを読み込んだ際には、他のCPUによって書き込まれた値であっても最新の値が読み出される状態**と定義。  

このcoherenceの保ち方にも様々な方式があるが、現在の主流は、書き込み時に他のcacheを無効にするwrite-invaliddate方式。  
無効にさせるだけでなく、有効な値もわかっているので教えればいいように思われるが、値の送信に時間がかかったり、使用されない場合でも更新処理を行う点のデメリットから主流になっていない。


### MSIプロトコル

CPU間でcacheをやり取りするためのprotocol。  以下の動作を実現する。  

* 書き込み時に最新の値以外を消す、write-invalidate
* 読み出しミス時に、メモリよりも先に他のCPU cacheから値を探す


## 記憶階層

| Component    | Latency      | Capacity     |
| ---          | ---          | ---          |
| CPU Register | 300 - 500 ps | 100 - 200 B  |
| L1 Cache     | 1 ns         | 10-100 KB    |
| L2 Cache     | 5-10 ns      | 8-32 MB      |
| Memory       | 50-100 ns    | 8-64 GB      |
| Disk         | 50-100 us    | 256 GB -2 TB | 
