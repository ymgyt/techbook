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

## 比較命令

比較結果を格納する特別なflag registerはない

## 分岐命令


## ECALL

KernelからSBIの機能を実行できる..?

## 擬似

assemblerでは使えるが内部的には別の命令で実現されている命令

* `mv rd, rs1`
  * `rs1`の内容を`rd`にcopyする
  * `addi rd, rs1, 0`のようにaddと0の加算で実現される


## 特権命令

### `mret` `sret`

*M*achine-mode/*S*upervisor-mode trap *RET*urn


### `wfi`

*W*ait *F*or *I*nterrupt
とくにやることがない時に使える
