# Systemcall


## Kernel 2.6までのsystemcallのやり方

x86が前提

1. 呼びたいsyscallに対応する数を`eax` registerに登録(writeなら1)
2. `int 0x80`命令を実行
3. 割り込みが発生してsyscall handling用のhandlerが`eax`の値に応じて処理する

