# tar

* archive(fileをまとめる)したあとに圧縮するのが一般的なので`.tar.gz`だったり、`tgz`になる

## UnArchive

```sh
# xxx.tar.gzがfile systemに残らないメリットがある
# tar.gzが解凍されたdirectoryがcurrentに残る
curl -sSL https://get.helm.sh/helm-v${VERSION}-${OS}-amd64.tar.gz | tar -xz


# list
tar --list --file filename
```

* `-x|--extract`
* `-t|--list`

### tar + gz

```shell
tar -xzvf xxx.tgz
```

