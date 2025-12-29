# TUN/TAP

## TUN

* Kernelからみると`struct net_derive`にみえる
  * いわゆる仮想NIC
* Userspaceからみると`/dev/net/tun` というchar deviceにみえる

Userspaceは

```sh
fd = open("/dev/net/tun", O_RDWR);
ioctl(fd, ....);
```

別applicationが`curl http://10.0.0.2` のようにnetwork callをすると
syscall -> TCP/IP stack -> Routing decision -> tun drivder -> fdにcopy
