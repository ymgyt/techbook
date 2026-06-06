# rg

## options

* `-i`: case-insensitive

### include exclude

```sh
# Rust fileのみ
rg -g '*.rs'

# target directoryを除外
rg -g '!target/'
```

* `-g`でincludeを指定できる。`!`でexcludeを表現する
