# RISC-V Registers

* RV32Iでは32個ある
  * pcは汎用registerではない
    * ARM-32ではpcがregisterだった

| Hard  | ABI       | Description    | Caller/Callee |
| ---   | ---       | ---            | ---           |
| `x0`  | `zero`    | Zero固定       | -             |
| `x1`  | `ra`      | Return address | -             |
| `x2`  | `sp`      | Stack pointer  | -             |
| `x3`  | `gp`      | ???            | -             |
| `x4`  | `tp`      | Thread pointer | -             |
| `x5`  | `t0`      | Temp           | Caller Saved  |
| `x6`  | `t1`      | Temp           | Caller Saved  |
| `x7`  | `t2`      | Temp           | Caller Saved  |
| `x8`  | `s0`/`fp` | Temp           | Calllee Saved |
| `x9`  | `s1`      | Temp           | Calllee Saved |
| `x10` | `a0`      | 引数/戻り値    | -             |
| `x11` | `a1`      | 引数/戻り値    | -             |
| `x12` | `a2`      | 引数           | -             |
| `x13` | `a3`      | 引数           | -             |
| `x14` | `a4`      | 引数           | -             |
| `x15` | `a5`      | 引数           | -             |
| `x16` | `a6`      | 引数           | -             |
| `x17` | `a7`      | 引数           | -             |
| `x18` | `s2`      | Temp           | Callee Saved  | 
| ...   | ...       | ...            | ...           | 
| `x27` | `s11`     | Temp           | Callee Saved  | 
| `x28` | `t3`      | Temp           | Caller Saved  |
| ...   | ...       | ...            | ...           | 
| `x31` | `t6`      | Temp           | Caller Saved  |

* `ra`: 関数呼び出し時に呼び出し元のaddress
* `tp`: thread local用






## CSR

Control and Status Registerという特殊なregister群がある。

* CSRには12bitのaddressがある
  * これは`scause`のような名前のregisterとは別?
    * 内部的にはaddressが付与されている(mcauseは0x300等)

* CSR関連の命令はZicsr拡張

* `mcycle`: CPUが起動してからのcycle数のcount


### 例外関連

* `scause`: 例外の種別を保持
* `stval`: 例外の付加情報(原因となったメモリアドレス等)
  * 4byte alignが前提。下位2bitにはmodeを表すflagを保持している
* `sepc`: 例外発生時のpc
* `sstatus`: 例外発生時の動作モード(U-Mode/S-Mode)

* `mstatus`: 現在の動作状況
* `mie`: machine modeの割り込み許可

### 仮想address

* `satp`: S-modeにおける仮想addressの変換のbaseとなるaddress

