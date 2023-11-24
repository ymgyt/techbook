# atomic

* atomicとは、読み込み/書き込みが中途半端な状態で観測されないという意味。
* supportにはplatform(CPU)の機能が必要なので`Atomic<T>`のようにgenericになっていない(Cellとは違う)

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
* 変数A,Bに対しておこなった操作について他のthreadからどの順番でみえるか保証されない


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
* 第3引数は成功(第一引数と現在の値が同じ)場合のread-modify-write操作のorder
* 第4引数は失敗(第一引数と現在の値が違う)場合のload操作のorder

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

#### compare_and_exchange_weak

* 第一引数の値が現在の値と同じ場合でも失敗する場合がある
  * 第一引数と同じ値がErrで返ってくる可能性がある
  * そのかわり実行効率がよい

## happens-before relationship

先行発生関係。  
メモリモデルでは、機械語命令、キャッシュ、バッファ、命令のreorder、compilerの最適化についてなにも規定しておらず、あることが別のことよりも先におこることだけを保証している。具体的には

* 同一thread内で起こることはすべて順番通り
* threadのspawn()とjoin()

### Total modification order

Relaxedにおいて一つのatomic変数に対する変更はすべてのthreadから同じ順番で観測されることが保証される。

```rust
static X: AtomicI32 = AtomicI32::new(0);
fn a() {
    X.fetch_add(5, Relaxed);
    X.fetch_add(10, Relaxed);
}
```
この場合はXは0 -> 5 -> 15と変化する。他のthreadが以下の観測になることはありえる

* 0  5  15
* 0  0  15
* 0  0  0

一方、以下は起こらない

* 0  5  0
* 0  10  15

一つのatomic変数の変更順序が複数ありえても、観測される順番はすべてthreadで同じになる

### Release Acquire order

* Releaseはstore操作に適用される
  * fetch_and_modify, compare_and_swapで利用するとstoreのみに適用
* Acquireはload操作に適用される
  * fetch_and_modify, compare_and_swapで利用するとloadのみに影響
* AcqRelはloadについてはAcquire, storeについてはReleaseになる

* **Acquire load操作がRelease store操作の結果を観測したときに先行発生関係が形成される**
  * storeとそれに先行するすべてが、loadとそれに続くすべてよりも先行発生する

```rust
use std::{
    sync::atomic::{AtomicBool, AtomicU32, Ordering::*},
};

static DATA: AtomicU32 = AtomicU32::new(0);
static READY: AtomicBool = AtomicBool::new(false);

fn main() {
    thread::spawn(|| {
        DATA.store(123, Relaxed);
        READY.store(true, Release); // このstoreよりも前がみえる(happen)
    });

    while !READY.load(Acquire) { // ここでreleaseを観測
        thread::sleep(Duration::from_millis(100));
        println!("waiting...");
    }

    assert_eq!(DATA.load(Relaxed), 123);
}
```

`READY.load(Acquire)`がtrueをReleaseで設定されたtrueを観測すると、releseの以前の操作(DATAへの123のstore)がみえることが保証される