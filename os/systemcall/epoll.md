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

## systemcall

* `epoll_create`: kernel内部にepoll instanceを作り、そのfile descriptorを返す。後続のsystemcallではこのfdを利用する 
* `epoll_ctr`: epoll instanceの関心があるfd(fileとかnetwork)を追加したり、削除したりする
* `epoll_wait`: epoll instanceに記載しているfdのlistのいずれかがreadyになるまでblockingする
  * このsyscallでlistを渡すのではなく、fdのlistはあらかじめkernelにepll_ctrで教えているのが改善点

## References

* [LWN.netの解説](https://lwn.net/Articles/520012/)
  * The (Linux-specific) epoll API allows an application to monitor multiple file descriptors in order to determine which of the descriptors are ready to perform I/O. The API was designed as a more efficient replacement for the traditional select() and poll() system calls.
