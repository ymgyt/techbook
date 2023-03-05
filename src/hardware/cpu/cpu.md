# CPU

## Architecture

* IA-32: intelの32bit
  * i386: intelの16bit x86を32bitに拡張
  * i686
* IA-64: intelの64bit
  * IA-32とは互換性なし
* x86-64: AMD64
  * IA-32と互換性有り
  * Intel 64は互換性ある

### Pipeline

前の命令実行中の状態で次の命令の実行を開始する概念。

### スーパースカラ

1 pipleline stageで同時に複数の命令を実行できる概念。
