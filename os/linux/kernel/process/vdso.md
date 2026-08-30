# vDSO

virtual Dynamic Shared Object

* dynamic libと仮想アドレスのmemory regionを指す場合がある(文脈)

* kernelが自動で全processにmapする共有lib
  * auxv(補助vector)でlinkerにアドレスを渡している
* `man 7 vdso`

* appが`clock_gettime()`を呼ぶ
  * libcがvDSO symbol `__vdso_clock_gettime`をruntime(link時)に発見している
  * usermodeのまま、call
  * vDSOの`__vdso_clock_gettime`がvvarのデータを読んで時刻を取得
  * syscallなしで現在時刻を返す

## メンタルモデル

1. userspaceからkernel権限を要求せずに実行させてもいいsystem callがある
  * 現在時刻の取得等
2. kernel spaceの関数の実装をmmapでuserspaceにみせればいい
3. 生の関数だと取り回しが悪いので、ELF + so 形式にしておく
4. dynamic linkerにsymbol table処理させて普通の関数のようにみせる

## vvar

* kernelがmapする読み取り専用の共有データ
* vdsoの関数がこれを読み取り現在時刻を返せる

## References

* [LWN: Implementing virtual system calls](https://lwn.net/Articles/615809/)

## vsyscall

* kernelに最初に実装された特定のsystem callを高速化する仕組み
