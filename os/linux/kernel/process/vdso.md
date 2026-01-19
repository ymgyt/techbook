# vDSO

virtual Dynamic Shared Object

* kernelが自動で全processにmapする共有lib
  * auxv(補助vector)でlinkerにアドレスを渡している
* `man 7 vdso`

## References

* [LWN: Implementing virtual system calls](https://lwn.net/Articles/615809/)

## vsyscall

* kernelに最初に実装された特定のsystem callを高速化する仕組み
