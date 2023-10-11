# CPU Metrics

cpuのmetrics取得toolでcpuの利用率を確認すると、userやsystem等のcategoryに分類される。これらのcategoryが何を意味するかについて

`/proc/stat`が情報源。これらは相互に排他的らしい。

## system(sy)

kernelが利用した時間。  
device driverやkernel module。

## user(us)

user space processが利用した時間。


## nice(ni)

positiveのnicenessをもつprocessによって利用された時間
userとniceの関係が知りたい。


## idle(id)

cpuが使われていない時間。  
内部的にはpriorityが最も低いtaskが使っている時間らしい。


## iowait(wa)

idleのsubcategory。  
swappだったり、I/Oの待ち時間のこと。

## hardware interrupt(hi, irq)

## software interrupt(si, softirq)


## steal(st)

virtual machineのときに他のvmがcpuを使っている時間。

## guest

vmが使っている時間