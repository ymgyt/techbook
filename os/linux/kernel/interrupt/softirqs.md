# softirqs

* CPUごとに`ksoftirqd/n`がいる(nはCPU番号)

```sh
systemd-cgls -k | rg ksoft
├─   15 [ksoftirqd/0]
├─   25 [ksoftirqd/2]
├─   31 [ksoftirqd/4]
├─   37 [ksoftirqd/6]
├─   43 [ksoftirqd/8]
├─   49 [ksoftirqd/10]
├─   55 [ksoftirqd/12]
├─   61 [ksoftirqd/14]
├─   67 [ksoftirqd/1]
├─   73 [ksoftirqd/3]
├─   79 [ksoftirqd/5]
├─   85 [ksoftirqd/7]
├─   91 [ksoftirqd/9]
├─   97 [ksoftirqd/11]
├─  103 [ksoftirqd/13]
├─  109 [ksoftirqd/15]
```
