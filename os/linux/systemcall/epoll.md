# epoll

* OSが管理するqueueにI/Oの進捗を表現したhandleを複数登録する
* 登録したhandle(I/O)のいずれかに進捗(read,writeできる)があるまで、blockする
* 戻り値は準備ができたhandleを複数返すので、I/Oを実施する

## Level triggerとEdge trigger

* level trigger
  * readの場合はdataがbufferにある限り、通知され続ける
  * bufferをdrainしない限り、同じeventが複数回通知される

* edge trigger
  * readの場合、bufferが空からdataを持つ状態になると通知される
    * bufferが空 -> fullで1度だけ通知される
  * bufferを一度空にしないと通知されない

## systemcall

* `epoll_create`: kernel内部にepoll instanceを作り、そのfile descriptorを返す。後続のsystemcallではこのfdを利用する 
* `epoll_ctr`: epoll instanceの関心があるfd(fileとかnetwork)を追加したり、削除したりする
* `epoll_wait`: epoll instanceに記載しているfdのlistのいずれかがreadyになるまでblockingする
  * このsyscallでlistを渡すのではなく、fdのlistはあらかじめkernelにepll_ctrで教えているのが改善点

## References

* [LWN.netの解説](https://lwn.net/Articles/520012/)
  * The (Linux-specific) epoll API allows an application to monitor multiple file descriptors in order to determine which of the descriptors are ready to perform I/O. The API was designed as a more efficient replacement for the traditional select() and poll() system calls.

## Userspace example

```rust
use std::{fs::OpenOptions, io, mem, os::fd::AsRawFd as _};

use anyhow::bail;
use tracing::info;

fn main() -> anyhow::Result<()> {
    tracing_subscriber::fmt::init();

    let f = OpenOptions::new()
        .read(true)
        .write(true)
        .open("/dev/devone0")?;
    let fd = f.as_raw_fd();

    let epfd = unsafe { libc::epoll_create1(0) };
    if epfd < 0 {
        bail!(io::Error::last_os_error());
    }

    let mut ev: libc::epoll_event = unsafe { mem::zeroed() };
    ev.events = libc::EPOLLIN as u32;

    ev.u64 = fd as u64;

    let rc = unsafe { libc::epoll_ctl(epfd, libc::EPOLL_CTL_ADD, fd, &mut ev as *mut _) };
    if rc < 0 {
        let err = io::Error::last_os_error();
        unsafe { libc::close(epfd) };
        bail!(err)
    }

    let mut events: [libc::epoll_event; 8] = unsafe { mem::zeroed() };

    let n = unsafe { libc::epoll_wait(epfd, events.as_mut_ptr(), events.len() as i32, 0) };
    if n < 0 {
        let err = io::Error::last_os_error();
        unsafe { libc::close(epfd) };
        bail!(err)
    }

    info!("epoll_wait retruned n={n}");
    #[expect(clippy::needless_range_loop)]
    for i in 0..n as usize {
        let ev = &events[i];
        let ready = ev.events;
        let token = ev.u64;
        info!("event[{i}]: token={token} events=0x{ready:x}");
        if ready & (libc::EPOLLIN as u32) != 0 {
            info!("  => EPOLLIN (redable)");
        }
    }

    unsafe { libc::close(epfd) };
    Ok(())
}
```
