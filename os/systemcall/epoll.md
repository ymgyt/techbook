# epoll

* OSが管理するqueueにI/Oの進捗を表現したhandleを複数登録する
* 登録したhandle(I/O)のいずれかに進捗(read,writeできる)があるまで、blockする
* 戻り値は準備ができたhandleを複数返すので、I/Oを実施する

## Level triggerとEdge trigger

* level trigger
  * readの場合はdataがbufferにある限り、通知され続ける
  * bufferをdrainしない限り、同じeventが複数回通知される

* edge trigger
  * readの場合、bufferが空からdataを持つ状態になると通知される
    * bufferが空 -> fullで1度だけ通知される
  * bufferを一度空にしないと通知されない
