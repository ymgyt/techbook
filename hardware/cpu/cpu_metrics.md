# CPU Metrics

cpuのmetrics取得toolでcpuの利用率を確認すると、userやsystem等のcategoryに分類される。これらのcategoryが何を意味するかについて

## system(sy)

kernelが利用した時間。

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