# Git Config

## `~/.gitconfig`

```text
[user]
    name = ymgyt
    email = yamaguchi7073xtt@gmail.com
[alias]
    a  = add
    co = checkout
    cm = commit
    s  = status
    b  = branch
[init]
    defaultBranch = main

[core]
    pager = delta
    # set global default gitignore
    excludesfile = ~/.gitignore

[interactive]
    diffFilter = delta --color-only

[delta]
    navigate = true  # use n and N to move between diff sections

[merge]
    conflictstyle = diff3

[diff]
    colorMoved = default
```

* `url.<base>.insteadOf xxx`
  * gitのコマンドで`xxx`を`<base>`の値に書き換える
  * protocolや認証情報を指定する際に利用できる
