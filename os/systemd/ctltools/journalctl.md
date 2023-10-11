# journalctl

* `man journalctl`

```shell
# unitを指定(--unit)
# --bootを付与すると現在のbootに限定できる
journalctl -u kubelet.service

# grep
journalctl -g fail --case-sensitive=false

# kernel
journalctl -k

# pidを指定
journalctl _PID=1234

# 特定の時間以降
journalctl -S '2023-01-29 14:30:00'
journalctl --since "2018-08-30 14:10:10" --until "2018-09-02 12:05:50"
journalctl -u apache2 -S yesterday -U today -o json --no-pager | tee apache2.json

# unitを指定してfollow
journalctl -u opentelemetry-collector -f

# diskの利用量
journalctl --disk-usage

# rotationの実行
journalctl --rotate --vacuum-time=5d

# bootの一覧
journalctl --list-boots
```