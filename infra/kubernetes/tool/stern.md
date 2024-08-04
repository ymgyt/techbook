# stern

## Usage

```sh
# stern <pod-query-regex>

# resourceを指定できる
stern deployment/foo -n kube-system --since 10m
```

* `--since <duration>`で直近duration以内から表示できる
  * 指定しないと48h時間前から表示される
* `--no-follow`で出力したらexit
