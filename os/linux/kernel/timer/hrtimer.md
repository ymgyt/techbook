# hrtimer

* `kernel/timers.c` とは異なるtimer subsystem
  * timer wheel は複数のtimeoutを効率的に管理できる
* hrtimer subsys自体はhigh-resolution clock sourceを提供しているわけではない
