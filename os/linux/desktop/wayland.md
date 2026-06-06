# Wayland

## Wayland Compositor

* DEによって実装が異なる
  * Gnomeの場合はmutter

* マウス操作
  1. kernel(evdev) -> compositor
  2. compositor が event をclient(window)にrouting


## Reference

* [Linuxデスクトップの背後で何が行われているのか](https://blog.ablaze.one/1613/2022-03-23/)
