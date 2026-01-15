# console

* `/dev/ttyS0`

## Memo

* UART
  * Registerで制御できるデバイス
  * x86ではI/O Port(0x3f8), ARM/RISC-VではMMIO
  * `serial8250_driver`はUARTを制御するdriver
* Serial Port
  * UARTにつながるインターフェース
* console
  * Kernelが`printk()`を出力する対象デバイス
  * `/dev/console`はprintkの出力先に設定されたTTY
* Serial console
  * serial port(UART)をconsoleに割り当てた場合
  * `console=ttyS0,115200`
