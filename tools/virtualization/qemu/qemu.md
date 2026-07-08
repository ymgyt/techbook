# QEMU

## Usage

```sh
qemu-system-riscv32 \
  -machine virt \
  -bios default \
  -nographic \
  -serial mon:stdio \
  --no-reboot
```

* `-machine`
  * `virt`: virtual machineとして起動する
  * `help`: supportされている一覧の表示
* `-bios`
  * `default` OpenSBIを使用
* `-nographic` windowなしで起動
* `-serial`
  * `mon:stdio` 標準入出力を仮想machineのserialに接続
* `--no-reboot` crash時に再起動せずに停止


## 起動後の操作

* `Ctrl+a c` debug console(monitor)に移行する
  * `q`で終了できる
* `Ctrl+a h` help
* `Ctrl+a x` exit


## Memo

```sh
# bootableなimg.binから起動
qemu-system-x86_64 -drive file=img.bin,format=raw
```
