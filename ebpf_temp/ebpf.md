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

この値に応じて、BPF programの引数(context)が決まる?

## eBPF map

* BPF programからは外部関数呼び出しで利用
* userlandからはsystem call
