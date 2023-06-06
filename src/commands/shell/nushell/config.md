# config

起動時に以下のfileが読み込まれる。

```sh
source path/to/env.nu
source path/to/config.nu
```

pathは以下で確認できる

* `$nu.env-path`
* `$nu.config-path`


## Alias

```nu
alias g = git
alias c = cargo
```

設定は`config.nu`に書いておく


