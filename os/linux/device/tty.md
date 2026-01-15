# tty

* `/dev/tty` は素直にdeviceにつながっていない
  * 物理的なdeviceがいるかもしれないしdriverしかいないかもしれない
* tty_structのようなkernelのobjectが間に介在している
  * line discipline のような処理ロジックがある
    * `struct tty_ldisc`
  * tty_driverへの参照も保持
  * termios ?

* `struct tty_driver`
  * open,close,write,ioctl時に呼ばれる関数を提供する(readがない)


```text
/dev/tty1 =>
struct tty_driver =>
struct tty_struct =>
(no hardware)


/dev/ttyS0 =>
struct tty_driver =>
struct tty_struct =>
serial8250 driver =>
UART registers
```
