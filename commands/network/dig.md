# dig

```sh
# dig <domain> <record-type>

dig blog.ymgyt.io A

# 最小出力
dig blog.ymgyt.io A +short
```

* record-type
  * `A`
  * `CNAME`
  * `TXT`

* options
  * `+short` 出力を短くする
  * `+trace` rootからのtrace
