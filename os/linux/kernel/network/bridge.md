# Bridge

## Memo

* VM eth0 - tap1 - br0 
* hostのeth0 と br0 もつながっている

* bridgeがIPをもつようにみえるのは、linuxがhostのnetwork stackに与えているIPを便宜上、bridgeに与えているから
  * bridgeには1つのhost interfaceがあり、これがhost protocol stackとつながっていると考えるとbridgeがIPをもっても不思議ではない


## References

* [Linux bridgeについて](https://zenn.dev/seiichihorie/articles/20250222-linux-bridge)
