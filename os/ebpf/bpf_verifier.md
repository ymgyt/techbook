# Verifier

* BPF programを検証する
* `linux/kernel/pbf/verifier.c`にsourceがある

## Verification steps

* Control Flow analysis
  * 命令のgraph(DAG)を作る
  * Depth first searchで無限loopを検出する
  * dead codeも検出する

* Data Flow Analysis
  * 実行をemulateして、registerやstack overflowを検出する
