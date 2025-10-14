# Paging

* pagetableという多段のtreeなデータ構造は物理メモリ上にある
* そのアドレスは特別なregisterに登録しておく
* 論理to物理は、MMUというCPU内のHWで行われる
  * したがって、pagetableはISAに含まれる
* pagetableが直接pageの物理アドレスを保持せず多段化させているのは、消費メモリ量をおさえるため

# MMU

* CPUに統合されているHW
  * 歴史的には独立していた時期も
* CPU命令の仮想アドレスを物理アドレスに変換する
* 変換の過程で、segfault 例外を創出する
* 仮想と物理アドレスの対応表であるページテーブルはkernelが設定する
* TLBというcacheをもつ
