# WASM Specification

## Memo

* boolがないi32の0以外がtrue,0がfalse
* 関数の引数/戻り値はstackに置いておく、置かれることで表現する
* String(文字列)はデータ型としてないので、自分でUTF8byte列をおいて表現する
* I/Oは組み込み環境側で実施する

## Memory

## Javascript

* i64のデータ型をWASM -> JSに渡せない
  * 内部的にはjsはf64になるが、f64ではi64を表現できないから
