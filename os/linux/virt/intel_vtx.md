# Intel VT-x

* 仮想マシン支援機能
* VM EntryでVMX root modeからVMX non-root modeに遷移する
  * Host stageが自動でstoreされ、Guest stateがloadされる
* VM ExitでVMX non-root modeからVMX root modeへ遷移する
  * Guest stateがstoreされHost stateがloadされる

* StateはVMCS(Virtual Machine Control Data Structure)というデータ構造で表現される
  * 仮想マシン実装がメモリ上に作る
  * vCPUがなぜ停止したかの情報もある
