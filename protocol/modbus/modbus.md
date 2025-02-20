# Modbus

* TCP portは502

## データの種類

* Coil
  * single bit
  * read/write 2値
  * DO(deviceの出力) をread
  * deviceの状態を変更するためにwrite

* Input Status(入力ステータス)
  * SpecではDiscretes Input とも
  * single bit
  * read only 2値
  * DI(deviceへの入力)をread

* Input Register(入力register)
  * 16bit
  * read only
  * AI(Analog Input) をread
    * sensorから読み取った値
  * addressを連続させることで倍精度のデータを表現したり

* Holding Register(保持レジスタ)
  * 16bit
  * read write
  * slave deviceの設定情報

## Address

* 各 data type(coil, input register,...)は 0 - 65535 のアドレスをもつ
  * Protocol上は0 origin
  * read input register 0 は input register 1(最初)を指す
* data typeのindexは 1 origin
  * input register 1 は最初のreigsterを指す

## Encoding

* big endian
   * 16bit register の値0x1234 は、0x12, 0x34 の順番でくる

## Reference

* [Modbus プロトコル概説書](https://www.mgco.jp/mssjapanese/PDF/NM/kaisetsu/nmmodbus.pdf)
