# cargo tree

```sh
# 誰が依存しているかを調べる
cargo tree -i libfoo
```


## Featuresの依存関係 

```sh
cargo tree -e feature

rustls v0.23.19
├── rustls feature "log"
│   └── rustls feature "logging"
│       └── tokio-rustls feature "logging"
│           └── tonic v0.14.3
```

* tonicがtokio-rutls の"logging" featureを有効化
 * それが、rutlsの"logging" featureを有効化
 * それがrutlsの "log" featureを有効化
