# udev

userspace /dev

* `/dev`のdevice file(node)を動的に管理する userspace process
  * `systemd-udevd.service`

* kernel内でdevice関連のeventが発生すると、netlink経由でuser spaceのudev daemonに通知が届く

* event処理
  * `/sysfs`を読む
  * ruleは`/etc/udev/rules.d`に定義する
    * `/usr/lib/udev/rules.d`
  * MODALIASに基づいて`modprove`でmoduleをloadしている
  * device nodeのアクセス権限を設定する
  * symbolic linkを作る

## Rules

* `man udev`だと
  * `/etc/udev/rules.d`
  * `/usr/lib/udev/rules.d`,`/usr/local/lib/udev/rules.d`
  * `/run/udev/rules.d`


## References

* [How does udev/uevent work?](https://unix.stackexchange.com/questions/550037/how-does-udev-uevent-work#:~:text=This%20application%20,instructions%20specified%20in%20udev%20rules)
* [Udev: Introduction to Device Management In Modern Linux System](https://www.linux.com/news/udev-introduction-device-management-modern-linux-system/#:~:text=Udev%20is%20the%20device%20manager,device%20names%20using%20Udev%20rules)
