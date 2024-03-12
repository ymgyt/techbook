# epoll

* OSが管理するqueueにI/Oの進捗を表現したhandleを複数登録する
* 登録したhandle(I/O)のいずれかに進捗(read,writeできる)があるまで、blockする
* 戻り値は準備ができたhandleを複数返すので、I/Oを実施する
