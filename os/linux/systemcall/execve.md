# execve

* execveを呼び出したprocessをexecveで指定されたプログラムを実行するprocessにする
* fork(clone) + execveで新しいプログラムの実行という挙動を実現している


## Flow

1. shellで`./hello`実行ファイルを実行
  * shellが`fork()`で子プロセスを作る
  * 子プロセスが`execve("./hello", argv, envp)`

--- kernel ---

2. helloのELFのProgram headerをparse
  * 仮想アドレスに`vm_area_struct` entryを追加していく
    * LEF PT_LOADに仮想アドレスにのせるべき情報が書いてある

3. PT_INTERPから`ld.so`を検出
  * 動的linkの前提
  * 同様にld.soのELFをparseして、仮想アドレスにエントリーを追加する

4. stackに初期データをのせる(Linux kernel ABI)
  * argc, argv, envp, NULL
  * auxv
    * helloのELF Program header tableのアドレス
    * Program Header数
    * helloのentry point
    * ld.soのbase アドレス

5. Program counterを`ld.so`のentry pointを設定

--- ld.so ---

6. auxvの情報から`ld.so`が`hello`のELFをparse
  * helloの`DT_NEEDED`を読んで動的linkが必要なentryを処理
    * ex. `libc.so.6`を解決して、ELFをopenして、PT_LOADを仮想アドレスに追加

7. relocation, 等の処理(わかってない)

--- hello ---

8. helloのentry point(`_start`)へジャンプ
  * `crt1.o`が定義
  * kernelが作ってくれたstackを読む
  ```text
  argc
  argv[0..]
  NULL
  envp[0..]
  NULL
  auxv
  ```

9. libcの`_libc_start_main(main, argc, argv,...)`を呼ぶ
  * libc内部を初期化
  * main(argc,argv)を呼ぶ
  * mainが返ってきたらexit
