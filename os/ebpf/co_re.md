# CO-RE

* Compile Once Run Everywhere
* 課題
  * 異なるkernel versionでもrecompileなしでbpf programを動かしたい

## 課題

bpf programはkernelのmemory空間で動作する。  
そのため、kernelの内部機能にアクセスできる利点がある。  
ただし、kernelのmemory layoutを制御することはできない。  
そして、kernelの型やデータ構造は変化する。(kernel configurationも影響する)
結果的に、bpf programをbuildするkernelのheaderを使ってcompileしてもdeploy先のkernelで動くとは限らない


### BCC(BPF Compiler Collection)のアプローチ

BCCはdeploy先、実行時にbpfのc programをlocalのkernel header(kernel-devel package)を使ってcompileする

このアプローチの問題点

* Clang/LLVMの分だけbinaryが大きくなる
* compile時にdeploy先のresourceを消費する(productionでbuildしてる)
* kernel headerが必要
* compile errorがruntime時に検出される(iterationが遅くなる)


## BTF (BPF Type Format)

* 型のdebug情報を保持
  * DWARFの代替
* `CONFIG_DEBUG_INFO_BTF=y`

```sh
bpftool btf dump file /sys/kernel/btf/vmlinux format c
```

で、`vmlinux.h`相当の情報を得られる

#### Compiler support

compilerがBTF relocationsという情報を埋め込んでいる..?

#### BPF loader

典型的にはlibbpf.  
bpf loaderは実行時のkernelの情報をもっているので、bpf programに必要な調整を行える。(offsetの調整とか)  
ayaはlibpbfに依存していないのでこのあたりを自前でやっている..?
