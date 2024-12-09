# CDN

## 仕組み

1. `foo.ymgyt.io` にCNAME recordを追加し、CDN vendor のdomainに解決する(`cdn.example.com`)
2. `cdn.example.com` へのアクセス時にCDN vendor はclient IP等の情報からedge(地理的に有利)のIPに解決する
3. edgeはcacheがあればそれを返す。なければorigin (`foo.ymgyt.io`)から取得する

## References

* [基礎から理解するCDN入門](https://www.bloomblock.net/media/cdn-basic-series/)
