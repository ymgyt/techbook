# Modbus

## データの種類

* Coil
  * read/write 2値
  * DO(deviceの出力) をread
  * deviceの状態を変更するためにwrite

* Input Status(入力ステータス)
  * read only 2値
  * DI(deviceへの入力)をread

* Input Register(入力register)
  * read only
  * AI(Analog Input) をread
    * sensorから読み取った値
  * addressを連続させることで倍精度のデータを表現したり

* Holding Register(保持レジスタ)
  * read write
  * slave deviceの設定情報
  * 16bit


## Reference

* [Modbus プロトコル概説書](https://www.mgco.jp/mssjapanese/PDF/NM/kaisetsu/nmmodbus.pdf)
