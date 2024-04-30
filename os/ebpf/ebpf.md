# eBPF

## 概要

* KernelにBPF VMがいる
* 様々なhookにVMの実行を設定できる
* VMのbyte codeを検証するVerifierがいる
* BPF命令以外にhelper関数を呼べる

## Userlandとのやり取り

* helper関数経由で、外部のデータ構造(eBPF map)にアクセスできる

## Program Type


* `BPF_PROG_TYPE`
* kernelの`include/uapi/linux/bpf.h`で定義される

以下が決まる

* BPF progが呼び出される場所
* 引数の型
* 引数のpointer先を変更できるか
* 戻り値の意味

## eBPF map

* BPF programからは外部関数呼び出しで利用
* userlandからはsystem call

## Tail Call

programの末尾(最後の命令)で他のBPF programを呼び出すこと。呼び出し後に呼び出し元に戻らない

## BPFのLife Cycle

1. BPF bytecodeを生成する
2. bpf system callでbytecodeをkernelに渡す
3. BPF Verifierで検証される
4. Program type,attachのeventに応じて、BPF programが実行される
5. BPF Map or buffer等の機構を通じて、userlandに情報を伝える
6. userlandも同様の機構で情報をやり取りする
