# time

## sleep

```rust
async fn example() {
    let interval = tokio::time::Duration::from_secs(1);
    tokio::time::sleep(interval).await;
}
```

## timeout

```rust
use tokio::time::timeout;
use tokio::sync::oneshot;

use std::time::Duration;

async fn example() {
    let (tx, rx) = oneshot::channel();

    // Wrap the future with a `Timeout` set to expire in 10 milliseconds.
    if let Err(_) = timeout(Duration::from_millis(10), rx).await {
        println!("did not receive value within 10 ms");
    }
}
```

* `Result<T, Elapsed>`にwrapされる

## tick

```rust
use tokio::time::{interval, Duration, MissedTickBehavior};

let mut interval = interval(Duration::from_millis(50));
interval.set_missed_tick_behavior(MissedTickBehavior::Delay);

task_that_takes_more_than_50_millis().await;
// The `Interval` has missed a tick

// Since we have exceeded our timeout, this will resolve immediately
interval.tick().await;

// But this one, rather than also resolving immediately, as might happen
// with the `Burst` or `Skip` behaviors, will not resolve until
// 50ms after the call to `tick` up above. That is, in `tick`, when we
// recognize that we missed a tick, we schedule the next tick to happen
// 50ms (or whatever the `period` is) from right then, not from when
// were *supposed* to tick
interval.tick().await;
```

* `MissedTickBehavior`: tick()後の処理が遅れた場合に、次にtick()を呼んだ場合の挙動
  * `Burst`
    * tick()が即座に解決される
    * 本来tick()が呼ばれるべき回数まで、burstする
  * `Delay`
    * 最後にtick()を呼んだ時間が基準になる
  * `Skip`
    * startからのperiodの期間に会うように、必要なら短くなるがburstはしない
