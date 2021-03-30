# tmux

## Install

```
# macOS
brew install tmux

# Ubuntu
sudo apt install tmux
```

## Usage

### Session

```
# sessionの開始
tmux

# 名前を指定して開始
tmux new -s <name>

# 終了
exit

# attach
tmux a

# sessionを指定してattach
tmux a -t <name>

# detach
Ctrl-b d

# attach中のseesion表示
Ctrl-b s

# list sessions
tmux list-sessions

# sessionを指定して終了
tmux kill-session -t <name>
```

### Window

```
# 作成
Ctrl-b c

# 指定したwindowに移動
Ctrl-b <number>

# next/privious
Ctrl-b n/p

# 名前の変更
Ctrl-b ,

# window一覧を表示
Ctrl-b w

# windowの終了
Ctrl-b &
exit
```

## 参考

[tmux入門](http://www.tohoho-web.com/ex/tmux.html)
 
