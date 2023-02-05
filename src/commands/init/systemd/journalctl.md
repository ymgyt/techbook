# journalctl

## Usage

```shell
# unitを指定
journalctl -u kubelet.service

# kernel
journalctl -k

# pidを指定
journalctl _PID=1234

# 特定の時間以降
journalctl -S '2023-01-29 14:30:00'

# follow
journalctl -f
```


* unitの名前がわからない場合

```shell
journalctl -F _SYSTEMD_UNIT
```
