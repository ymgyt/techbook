# Timer unit

* serviceを定義する必要がある
* `systemctl list-unit-files -t timer`
* `systemctl list-timers`
* `man systemd.timer`
* `man systemd.time`

```ini
[Service]
Type=oneshot
# nice range -20 ~ 19
# 19 lowest priority
Nice=19
IOSchedulingClass=2
IOSchedulingPriority=7

[Timer]
OnCalendar=weekly
AccuracySec=1h
Persistent=true
```

* `OnCalendar`: `man systemd.time`のCALENDAR EVENTSに実際の時間が書いてある
* `IOSchedulingClass`: `man systemd.exec`に書いてあるらしい
* `AccuracySec`: どの程度、遅れを許容するか。正確に実行したい場合は、`1us`
* `Persistent`: scheduling中にmachineの電源が落ちていた場合、boot後に実行するかどうか。falseならskipされる。