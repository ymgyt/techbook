# atomic

* atomicとは、読み込み/書き込みが中途半端な状態で観測されないという意味。

## Ordering

```rust
enum Ordering {
    Relaxed,
    Release,
    Acquire,
    AcqRel,
    SeqCst
}
```

* それぞれがdifferent restrictionsをCPU/compilerに課す。

### Relaxed

* guarantee nothing. atomicだけが保証の対象。


```rust
use std::sync::atomic::{AtomicBool,Ordering};
use std::thread::spawn;

static X: AtomicBool = AtomicBool::new(false);
static Y: AtomicBool = AtomicBool::new(false);

fn main() {
    let t1 = spawn(|| {
        let r1 = Y.load(Ordering::Relaxed);  // 1
        X.store(r1, Ordering::Relaxed);      // 2
    });
    
    let t2 = spawn(|| {
        let r2 = X.load(Ordering::Relaxed);  // 3
        Y.store(true,Ordering::Relaxed);     // 4
    });
    
    t1.join().unwrap();
    t2.join().unwrap();
    
    println!("{:?}", X);
    println!("{:?}",Y);
}
```

* t2において、3と4はreorderされる可能性がある。なので、r2がtrueになることがあり得る


## compare_and_exchange

* observeした値と、新しくしたい値を渡し、現在の値とobserveした値が同じだったら更新してくれる。
* updateに成功したらOkを返す,updateに失敗したらErrを返す
  * どちらにせよ現在の値も返す

```rust
static LOCK: AtomicBool = AtomicBool::new(false);
fn mutex(f: impl FnOnce()) {
// Wait for the lock to become free (false).
    loop {
        let take = LOCK.compare_exchange(
              false,
              true,
              Ordering::AcqRel,
              Ordering::Relaxed
          );
          match take {
            Ok(false) => break,
            Ok(true) | Err(false) => unreachable!(), 
            Err(true) => { /* .. TODO: avoid spinning .. */ } 
          }
    }
    // Call f while holding the lock.
    f();
    // Release the lock.
    LOCK.store(false, Ordering::Release); 
}
```
