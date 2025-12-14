# install

* src fileをcopyして、owner, mode, directory作成を行う
  * build成果物を配置するのがユースケース
  * cp, mkdir,chownをまとめるイメージ

```sh
install -Dm755 /target/release/foo /usr/local/bin/foo
```

* `-D`: mkdirする
* `-m755`: mode設定
