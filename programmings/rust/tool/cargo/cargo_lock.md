# Cargo.lock

## lib crateにCargo.lockをcommitするべきか

* `Cargo.lock`はcargoを実行したrootで参照される
  * commitしない場合は、実行毎にversionが解決されるので、リリースタイミングをまたいで挙動がかわる
  * これが実際に依存された場合の挙動ではある
* 昔はNoだったが、[Change in Guidance on Committing Lockfiles](https://blog.rust-lang.org/2023/08/29/committing-lockfiles/)でcommitしても良いという考えも示された
