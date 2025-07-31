# dig

```sh
# dig <record-name> <record-type> [options...]

dig blog.ymgyt.io A

# 最小出力
dig blog.ymgyt.io A +short

# 読みやすくする
dig blog.ymgyt.io soa +multiline
```

* record-type
  * `A`
  * `CNAME`
  * `TXT`

* options
  * `+short` 出力を短くする
  * `+trace` rootからのtrace
  * `+multiline` 読みやすくする
