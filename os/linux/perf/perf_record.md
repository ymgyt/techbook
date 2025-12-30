# perf record

```sh
sudo perf record -p 1234 -g -F 99 -- sleep 5
sudo perf report
```

* `--pid|-p`: processの指定
* `-g`: call graphを表示
* `-F 99`
  * samplingを一定周期で行う
  * 99にしているのはkernelの定期実行されてる処理とぶつからないようにするため


## perf report

* `e` call chainを展開する
* `c` 展開したcall chainを戻す
