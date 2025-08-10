# ip

## addr

```sh

# enp0s1234 に link local address を割り当てる
sudo ip addr add 169.254.100.1/16 dev enp0s1234
```


## neighbor

```sh
# ARPテーブルの確認
ip neigh show 
# ARPテーブルの手動設定
ip neigh add <ip_addr> lladdr <mac_addr> dev <dev> nud permanent
```

* `nud`: Neighbor Unreachability Detection
  * entryの持続性に関する設定
  * `permanent`永続
