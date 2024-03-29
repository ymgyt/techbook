# RISC-V Instruction

* overflowしてもregisterに記録されたり、例外がおきたりはしない

## Assembly

### Offset

メモリアドレスを表すオペランドの表記方法。  
registerに格納されたaddress + 即値immを`imm(reg)`で表す。

`lw a7, -4(a2)`は`a2` registerから`-4`減じた値を`a7`にsetする  
カッコで、offsetを表現できる。  
これがどこで定義されているか調べられていない。  
RISC-V特有なのかもわかっていないが、説明なしにでてくる。

### `imm[x:y]`

右から左に読んで、yからxbitまでを表現する

bitが`001001010010`で`bit[7:4]`は4から7bitなので`0101`を表現する

| Bit index | 11 | 10 | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
| Bit       | 0  | 0  | 1 | 0 | 0 | 1 | 0 | 1 | 0 | 0 | 1 | 0 |

### `imm[20|10:1|11|19:12]`

bitの参照範囲を並び替えたいというモチベーション。  
`x:y`はあくまで表現したいbitのindexを表す。元bitの範囲は左から順番に読むのでわかる。  
左から以下のように解釈する。
8bit(19:12)を表現したいbitの19から12に置く
次の1bit(11)を表現したいbitの11bit目におく  
次の10bit(10:1)を表現したいbitの10から1に置く
最後の1bit(20)を表現したいbitの20bit目に置く。

表現したいbitの0bit目がわからないがそこは仕様で決まっているはず

## メモリ関連

* `sw rs2 offset(rs1)`
  * Store Word。register rs2の値をrs1+offsetのメモリに書く

* `lw rd, offset(rs1)`
  * Load Word。rs1+offsetのメモリの値をrd regに書き込む

## 比較命令

比較結果を格納する特別なflag registerはない

## 分岐命令

* `bne rs1, rs2, offset`
  * Branch if Not Equal。rs1とrs2が等しくなければ、現在のpcにoffsetを加えてpcに書き込む
  * offsetにlabelがくるのは疑似?


* `jal rd, offset`
  * Jump and Link。次の命令addr(pc+4)をrd regに書き込み、現在のpc + offsetの値をpcに書き込む
    * 戻る場所を記録してjumpすることをjump and linkという
  * offset(imm)には0bit目の情報がない。これは命令addrは必ず2byte境界にalignされているから、必ず0になる情報はencodeする必要がないため。
  * `jal offset`のようにrdが省略されるとx1が想定される(疑似命令)

* `jalr rd, offset(rs1)`
  * Jump and Link Register
  * rs1の値のoffsetを加えたaddrにjupmする。現在のpcからの相対ではない。現在のpc + 4の値をrd regに書き込む
  * `jalr rs`のようにrdが省略されるとx1が想定される(疑似命令)

## 演算

* `addiw rd, rs1, imm`
  * Add Word Immediate。rs1+immの結果をrdに書き込む

## ECALL

KernelからSBIの機能を実行できる..?

## 擬似

assemblerでは使えるが内部的には別の命令で実現されている命令

* `mv rd, rs1`
  * `rs1`の内容を`rd`にcopyする
  * `addi rd, rs1, 0`のようにaddと0の加算で実現される

* `ret`
  * `jalr x0, 0(x1)`
  * 関数から戻る際に利用。x1にはjal,jalrで呼び出し元の次のaddrが入っているので、そこにjumpする。
  * 戻る際は呼び出し元のaddrの保持が不要なので、x0に書いている

* `li rd, imm`
  * Load Immediate。immの値をrdに書き込む。
  * lui,addiの両方またはどちらかに展開される

* `sext.w rd,rs1`
  * Sign-extend Word。rs1の下位32bitを符号拡張してrdに書き込む
  * `addiw rd, rs1, 0`になる

* `bnez rs1, offset`
  * Branch if Not Equal to Zero。
  * `bne rs1, x0, offset`

## Atomic

### LoadReservedとStoreConditional

２つの命令の合わせ技でread modify writeを安全に行う。

* `lr.w rd, (rs1)`
  * load reserved。rs1のメモリからrd registerに書き込む
  * loadされたメモリ予約済の印をつける
    * 各CPUが参照できる場所にrs1 addressにあるthreadからアクセスがあったことを記録する
    * 既に別のthread(cpu?)の記録があった場合は上書きする

* `sc.w rd, rs2, (rs1)`
  * store conditional。rs2 registerの4byteをrs1 addressに書き込む。storeに成功したらrdに0を、失敗したら0以外を書く。
  * load reserved命令で記録されたthreadと自身のthreadが一致するかを判定している

### Atomic Memory Operation

* `amoadd.w rd, rs2, (rs1)`
  * Atomic Memory Operation: Add Word
  * addr rs1の値とrs2を加算して結果を、rdとrs1のaddrに書く

### fence

* `fence pred,succ`
  * pred(先行)で示す先行メモリアクセスとI/Oをsucc(後続)で示す後続メモリアクセスとI/Oが可視化される前に他のthreadとdeviceに対して可視化する。
  * rはメモリread, wはメモリwrite
  * 引数が省略された場合は`fence iorw, iorw`

RISC-V Spec 2.7 Memory Ordering Instructionsでは  
> Informally, no other RISC-V hart or external device can observe any operation in the
successor set following a FENCE before any operation in the predecessor set preceding the FENCE.

他のthread(device)はfence命令に続くsuccessor operationをfenchより前のpredecessor oprationより前に観測しない


## 特権命令

### `mret` `sret`

*M*achine-mode/*S*upervisor-mode trap *RET*urn


### `wfi`

*W*ait *F*or *I*nterrupt
とくにやることがない時に使える

### CSR

