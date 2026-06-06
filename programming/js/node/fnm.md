# fnm

Fast Node Manager

## nushell

* Userが指定したversionのnodeを `FNM_MULTISHELL_PATH/bin` に配置する
  * なんらかの方法で、userのshellの`PATH` に `FNM_MULTISHELL_PATH/bin` を設定しておく必要がある

nu的には

```nu
if not (which ^fnm | is-empty) {
    # 環境変数の設定
    ^fnm env --json | from json | load-env
    # PATHの追加
    let node_path = match $nu.os-info.name {
      "windows" => $"($env.FNM_MULTISHELL_PATH)",
      _ => $"($env.FNM_MULTISHELL_PATH)/bin",
    }
    $env.PATH = ($env.PATH | prepend [ $node_path ])
}
```


```nu
# config.nu に追記
$env.config = ($env.config | merge {
    hooks: {
        env_change: {
            PWD: [{|before, after|
                if ([.nvmrc .node-version] | path exists | any { |it| $it }) {
                    ^fnm use --silent-if-unchanged
                }
            }]
        }
    }
})
```

まだ設定できていないが、hookしてdirectoryごとに切り替えるにはこういう感じ

https://dev.classmethod.jp/articles/how-to-use-fnm-on-nushell-202409/

## Install

```
cargo install fnm
```

in `.bashrc` (or shell rc)

```
eval "$(fnm env)"
```

## Usage

```sh

# list installable versions
fnm list-remote

# install
fnm install v16.13.1

# pin specific node version to project(directory)
fnm use v16.13.1

# set default version
fnm default v16.13.1
```
