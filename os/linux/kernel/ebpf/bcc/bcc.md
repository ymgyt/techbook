# BCC(BPF Compiler Collection)

1. C source codeを user-spaceのcontrol appに埋め込む
2. ctonrol appが実行対象のserverにdeployされる
3. BCCはembedded のClang/LLVMを呼び出し、localのkernel headerを読み込む
  * `kernel-devel` packageがserverにある前提

## 課題

* Clang/LLVMを埋め込む必要があるので、binary sizeが大きくなる
* compile時にproductionのresource(cpu)を消費する
* kernel headerがtarget systemに必要
