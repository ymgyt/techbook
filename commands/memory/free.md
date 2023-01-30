# free

## Options

### 単位の指定
```shell
 -b, --bytes
 -k, --kilo
 -m, --mega
 -g, --giga
 --tera 
 --peta 
 -h, --human
```

* `-h` は計算して最大の単位をつかってくれる


## 読み方

```shell
# free -h
              total        used        free      shared  buff/cache   available
Mem:           7.6G        1.4G        1.2G        135M        4.9G        5.8G
Swap:            0B          0B          0B
```

* 空きメモリは`avaiable`をみる
  * `buff/cache`のうち解放可能な値+freeの値
* `shared`はtmpfs
  * メモリだけどfilesystemとしてprocessに見せているのでprocess間でmemory共有できる