# ssh-keygen

## Create KeyPair

```shell
ssh-keygen -t rsa -b 4096 -f path/key -C ymgyt@xxx

ssh-keygen -t ed25519 -b 4096 -f nixos_key -C ymgyt
```

* `ed25519`のほうがrsaよりいいらしい

## 公開鍵のfingerprintを表示

```shell
ssh-keygen -lf path/to/store/public_key_file
```
