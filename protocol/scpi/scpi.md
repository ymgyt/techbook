# SCPI

* Standard Commands for Programmable Instruments
* 計測器を制御するためのコマンド言語

* CommandHeader + Parameter + Separator
  * `VOLTA 5.0`
* Queryの場合は`?`を最後につける

* 大文字が省略付加で小文字が省略可
  * `VOLTage`は`VOLT`

* 全機種共通コマンドとサブシステムコマンドがある
  * `*`からはじまるのが共通

## Data Types

* NR1: 整数データ
  * +12, -23
* NR2: 小数データ
* NR3: 浮動小数点データ
  * `+1.0E-2`



## Commands

### 共通

* `*IDN?`: 計測器の識別情報を取得
* `*RST` : 工場出荷時に初期化
* `*CLS` : エラー表示のクリア
  * EventStatus, Register,Queueのクリア


### 電圧 電流の設定

* `VOLT?` : 現在の出力電圧
* `CURR?` : 設定されている電流リミット


### 電圧 電流の計測値

* `MEAS:VOLT?` : 出力端子の実測電圧値の取得
* `MEAS:CURR?` : 出力電流の実測値の取得


### 出力制御

* `OUTP ON` : 出力をON
* `OUTP OFF`: 出力をOFF
* `OUTP:STAT?` : 出力状態の問い合わせ
