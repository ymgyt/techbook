# OOM

reclaim, swap, compaction でも十分な空き領域を作れなかったので、process を killすること

## 流れ

1. processがmalloc等でメモリを割り当てる
2. 仮想アドレスを予約
3. 実際に利用
4. page fault
5. 物理アドレス割当
6. 足りない場合、reclaim, swap, compaction
7. それでも無理な場合、OOM
8. OOM Killer が victim を選定
9. SIGKILL

## /proc

* `/proc/<pid>/oom_score`
* `/proc/<pid>/oom_score_adj`
