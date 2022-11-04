# chown

ファイルの所有者を変更する。

## Usage

```shell
# fileのownerをnew-ownerに変更する。
sudo chown <new-owner> <file>

# config fileのowner,groupを現在のuserのものにする
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

* `sudo`していても`$(id -u)`はsudo前のuserの値を返してくれる
