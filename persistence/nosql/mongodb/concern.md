# Concern

## Write concern

[公式](https://www.mongodb.com/docs/manual/reference/write-concern/)

Mongodbへの書き込み時に指定できるparameter。  

* `w`: write concernの指定
  * `w: n`: `w: 1`の場合1台(primary)への書き込みを要求する
  * `w: majority`: majority数の書き込みまで要求する
* `journal`: diskへの書き込みまで要求するかどうか
  * `true`: diskに書き込めてから成功が返る
  * `false`: memoryへの書き込みで成功を返す
* `timeout`: 一般的なtimeout


## Majority

majorityの算出方法としては

* arbiterを含む投票可能なノードの過半数
* データノードの数

のうち少ない数がmajorityとして扱われる。
