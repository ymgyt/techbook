# ldd

binaryにlinkされたlibraryを表示する

```shell
ldd /bin/echo
    linux-vdso.so.1 (0x00007fffba3fa000)
    libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f0bd00d3000)
    /lib64/ld-linux-x86-64.so.2 (0x00007f0bd02dd000)
```
