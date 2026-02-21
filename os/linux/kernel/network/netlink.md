# Netlink

* `man 7 netlink`
* socketでkernelとprocessがやり取りする仕組み(IPC)

```c
netlink_socket = socket(AF_NETLINK, socket_type, netlink_family);
```

## References

* [新Linuxカーネル解読室 - Netlink](https://www.valinux.co.jp/blog/entry/20260219)
