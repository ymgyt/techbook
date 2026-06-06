# console

* Kernelが`printk()`を出力する対象デバイス
* `/dev/console`はprintkの出力先に設定されたTTY

`printk()`の出力候補は複数ある、UART,画面(VGA),仮想端末、log buffer
これを抽象化するのがconsole
printk()を処理できるrole

## Memo

* UART
  * Registerで制御できるデバイス
  * x86ではI/O Port(0x3f8), ARM/RISC-VではMMIO
  * `serial8250_driver`はUARTを制御するdriver
* Serial Port
  * UARTにつながるインターフェース
* Serial console
  * serial port(UART)をconsoleに割り当てた場合
  * `console=ttyS0,115200`
