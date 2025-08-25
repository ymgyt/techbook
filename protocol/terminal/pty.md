# Terminal Emulatorの仕組み

Terminal emulator(alacritty)とshellのメンタルモデルについて

* TEはsystemcallでptyをopenする
  * ptyはプロセス間通信用のpipe
  * slave側のfdをshellに渡す
    * `/dev/pts/`はslaveのfd
  * master側をTEが保持する

* shellのslaveへの書き込みはTEのmasterから読め
* TEのmasterへの書き込みはshellのslaveから読める
  * masterへの書き込みは行志向なのでenterが押されるまで、kernel側でbufferされる
  * raw modeはこのあたりの挙動を変える
* TEはwayland compositorからのkey入力eventをうけとると、masterに書き込む

* shellはslaveへの書き込みにASCII escape を利用して単純なtext以上の情報を伝達する
  * cursor position等

* Cursor positionをTEが知る必要があるのは、その位置をwayland compositorに知らせることで、IMEの変換が正しい場所にでるようになる


## Raw Mode

* masterへの書き込み時のkernel側の挙動をかえる
* STDIN(slave)は1文字単位で読める
* Echo disabled
* Ctrl-Cがsignalになったりしなくなる
