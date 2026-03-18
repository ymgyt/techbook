# Congestion Control

輻輳制御について。
詰まる要因としては、受信側のapp(buffer)と途中のネットワークが関係してくる

* `cwnd`
  * 接続において、流してよいデータ量の上限
  * flight size, in-flightといわれる

* `rwnd`
  * 通信相手のbuffer

未ACKデータ量 < min(rwnd, cwnd) の制約を満たす
