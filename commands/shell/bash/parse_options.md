# Parse Options

引数,optionsのparse


```sh
abort() { echo "$*" >&2; exit 1; }
unknown() { abort "unrecognized option '$1'"; }
required() { [ $# -gt 1 ] || abort "option '$1' requires an argument"; }
FLAG_A='' FLAG_B='' ARG_I='' ARG_J=''

while [ $# -gt 0 ]; do
  case $1 in
    -a | --flag-a) FLAG_A=1 ;;
    -b | --flag-b) FLAG_B=1 ;;
    -i | --arg-i ) required "$@" && shift; ARG_I=$1 ;;
    -j | --arg-j ) required "$@" && shift; ARG_J=$1 ;;
    -?*) unknown "$@" ;;
    *) break
  esac
  shift
done


```

## Memo

`getops`,`getopt`それぞれ問題を抱えている


## 参考

https://qiita.com/ko1nksm/items/7d37852b9fc581b1266e