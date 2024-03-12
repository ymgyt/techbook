# Asynchronous Programming

非同期全般の話

## Pre-empt

Schedulerがtaskの実行を強制的に停止できるかどうか。 
ここでいうshcedulerはOSかもしれないし、runtimeかもしれない。  
taskはOSのthreadかもしれないし、(futures,goroutine,...)かもしれない。 

* pre-empt: schedulerがtaskを停止させること
  * Non cooperativeとも
* non pre-empt: schedulerからはtaskを停止できないので、task側が明示的に実行をschedulerに返す必要がある。この制御を返す動作をyieldと言われたりする
  * Cooperativeとも


## Green thread

M:N Threadingとも。　　
program側で、CPU registerやstackを管理して、spやinstrument pointerをassemblyで書き換えて、複数のthread(実行)を作り出すこと。  
OSからみると、ずっと実行している1つのthreadにみえる。  
