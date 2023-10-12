# execve

* execveを呼び出したprocessをexecveで指定されたプログラムを実行するprocessにする
* fork(clone) + execveで新しいプログラムの実行という挙動を実現している