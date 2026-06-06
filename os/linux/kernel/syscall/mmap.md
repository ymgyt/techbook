# mmap

```c
void *mmap(
  void *addr,
  size_t length,
  int prot,     /* 仮想アドレスの許可(R/W/X)      */
  int flags,    /* shared/private, file/anonymous */
  int fd,       /* file baseな場合                */
  off_t offset, /* file baseな場合のoffset        */
);
```


## Usecase

```c
/* fileの読み込み */
void *p = mmap(NULL, len, PROT_READ, MAP_PRIVATE, fd, 0);

/* fileの編集 */
void *p = mmap(NULL, len, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);

/* 匿名メモリの確保
   malloc()が大きい領域を確保する場合とか? */
void *p = mmap(NULL, len, PROT_READ|PROT_WRITE,
               MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
```
