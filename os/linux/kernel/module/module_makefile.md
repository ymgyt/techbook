# Kernel module Makefile

* `K_DIR`は典型的には`/lib/modules/$(uname -r)/build`

Makefile
```make
obj-m := hello.o

KDIR ?= $(K_DIR)
PWD := $(shell pwd)

modules:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean

insmod:
	sudo insmod ./hello.ko
	sudo dmesg -T | rg "hello:"

rmmod:
	sudo rmmod hello
	sudo dmesg -T | rg "hello:"
```

hello.c
```c
#include <linux/module.h>
#include <linux/kernel.h>

static int __init hello_init(void)
{
  pr_info("hello: loaded\n");
  return 0;
}

static void __exit hello_exit(void)
{
  pr_info("hello: unloaded\n");
}

module_init(hello_init);
module_exit(hello_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("ymgyt");
MODULE_DESCRIPTION("hello module");
```
