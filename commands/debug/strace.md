# strace

* 実行するbinaryで発行されるsystem callを表示する

## Usage

```shell
# 出力結果をfileに書き出す
strace -T -o trace.log ./app
```

* `-o` 出力fileを指定
* `-T` system callの実行時間を表示(sec)
