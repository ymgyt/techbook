# tmux config

* `~/.tmux.conf`がpath

## prefix key

```
# remap default prefix key
unbind C-b
set-option -g prefix C-j
bind-key C-j send-prefix
```

* defaultだとCtrl-bがprefixなのでそれをCtrl-Cに変更する

## window managing
```
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %
```

* remapping window split key

## etc

* `set-option -g escape-time 0`
  * ESC押したあとに待機する時間を0にする。これをいれておかないとhelixでnormal modeに移行する際にdelayがでてしまう。

* `bind r source-file ~/.tmux.conf`
  * reload処理をできるようにする
  
