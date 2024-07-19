# eBPF

## 概要

* Linux kernelのsubsystem
* KernelにBPF VMがいる
* 様々なhookにVMの実行を設定できる
* VMのbyte codeを検証するVerifierがいる
* BPF命令以外にhelper関数を呼べる
* bpf programはevent drivenでkernelやapplicationが特定のhook pointに到達すると呼ばれる
  * network event, system cll, function entry/exit, kernel tracepoints

## Components

| Component    | Location  | Functionality                        |
| ---          | ---       | ---                                  |
| Compiler     | Userspace | BPF programをbytecodeに変換          |
| bpf syscall  | Kernel    | bpf bytecodeをkernelにload           |
| verifier     | Kernel    | bpf programを検証                    |
| JIT compiler | Kernel    | bytecodeをmachine instructionsに変換 |
| VM           | Kernel    | bpf programを実行                    |

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

BPF programの命令数に制限があり、これに対処するために複数のbpf programをchainさせている

現状の制限は
* 1M instructions
* 32 chain call

## BPFのLife Cycle

1. BPF bytecodeを生成する
2. bpf system callでbytecodeをkernelに渡す
3. BPF Verifierで検証される
  * 検証に失敗するとbpf system callが-1を返す
4. Program type,attachのeventに応じて、BPF programが実行される
5. BPF Map or buffer等の機構を通じて、userlandに情報を伝える
6. userlandも同様の機構で情報をやり取りする

## JIT Compilation

kernelのconfig `CONFIG_BPF_JIT`が有効になっているとbpf bytecodeはkernelにloadされたあとnativeのinstruction setにcompileされる  

## Kernel Configuration

bpf関連のconfig

* `CONFIG_BPF_JIT`: JITの制御
* `CONFIG_DEBUG_INFO_BTF`: BTFの保持の制御


## `vmlinux.h` fileとは

BPFで生成したlinux kernelに関する型情報。  
kernel headerへの依存をなくせる利点がある
