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
