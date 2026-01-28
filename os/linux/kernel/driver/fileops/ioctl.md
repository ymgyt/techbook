# ioctl

```c
static long int devone_ioctl(struct file *filep, unsigned int cmd,
                             unsigned long arg)
```

* `unsigned long arg`はuserspaceのpointerが入っている。
