# wpctl

```sh
wpctl status
```

## Mute

```sh
wpctl set-mute <node_id> (1|0|toggle)

# Node3をmute
wpctl set-mute 3 1
```

* 1: mute
* 0: unmute
* toggle


## Volume controll

```sh
wpctl set-volume <node_id> 0.50
```

## Speaker 出力先変更

```sh
# node_idを出力先にする
wpctl set-default <node_id>
```

