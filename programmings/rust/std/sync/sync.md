# std::sync

## Arc

## Mutex

* lockしたthreadしかunlockできないようにlockの戻り値のGuardのdropにunlockが実装されている
  * lockを取得したthreadがpanicすると、lock()のResultがErrになる
* into_inner()で中身取り出せる

### MutexGuardの生存期間

```rust
let list: Mutex<Vec<i32>> = todo!();
if let Some(item) = list.lock().unwrap().pop() {
  process_item(item)
}
```

この処理はprocess_item()実行中もlock状態となってしまう。  
正しくは以下。

```rust
let item = list.lock().unwrap().pop();
if let Some(item) = item {
  process_item(item);
}
```

## RwLock

* 3つの状態を遷移する
  * lockされていない
  * writerによる排他lock
  * 任意の数のreaderのlock
* write()のRwLockWriteGuardがDerefMutを実装している
* RefCellのmulti thread版
* read lockされている場合にwrite()が呼ばれると後続のreadがblockされる
  * 実装はplatformごとに違う..?

## Condvar

Mutexで保護したresourceが特定の条件を満たすまで待機したい場合がある。  
例えば`Mutex<Vec<Iem>>`でvecになんらかのitemがpushされるまで待機したい等。  
Mutexだけでは都度lockを取得して、vecのlen()を確認する必要がある。  
Condvarは保護されたresourceに対しての待機のメカニズムを提供する

```rust
use std::sync::{Condvar, Mutex};

fn main() {
    let queue = Mutex::new(VecDeque::new());
    let not_empty = Condvar::new();

     thread::scope(|s| {
        s.spawn(|| loop {
            let mut q = queue.lock().unwrap();
            let item = loop {
                if let Some(item) = q.pop_front() {
                    break item;
                } else {
                    q = not_empty.wait(q).unwrap();
                }
            };
            drop(q);
            dbg!(item);
        });

        for i in 0.. {
            queue.lock().unwrap().push_back(i);
            not_empty.notify_one();
            thread::sleep(Duration::from_secs(1));
        }
    });
}
```

* `Condvar::wait()`にguardが必要なのは、unlockしてからwaitするまでの間に通知がきた場合それを見逃してしまう可能性があるから
  * waitするまでguardを手放さなければ、通知側をまたせられる
* wait_timeout()もある


## OnceLock

* 複数threadからアクセスできる(Sync)、一度だけ初期化したい型を提供する

```rust
use std::sync::OnceLock;

fn instrumentation_scope() -> &'static InstrumentationScope {
    static INSTRUMENT_SCOPE: OnceLock<InstrumentationScope> = OnceLock::new();

    INSTRUMENT_SCOPE.get_or_init(|| InstrumentationScope {
        name: env!("CARGO_PKG_NAME").to_owned(),
        version: env!("CARGO_PKG_VERSION").to_owned(),
        attributes: Vec::new(),
        dropped_attributes_count: 0,
    })
}
```

## LazyLock

* OnceLockをwrapしたかた
  * LazyLockでよいならOnceLockよりこちらを使う?
* 宣言時に初期化用のclosureを渡せる
 

```rust

// n.b. static items do not call [`Drop`] on program termination, so this won't be deallocated.
// this is fine, as the OS can deallocate the terminated program faster than we can free memory
// but tools like valgrind might report "memory leaks" as it isn't obvious this is intentional.
static DEEP_THOUGHT: LazyLock<String> = LazyLock::new(|| {
    // M3 Ultra takes about 16 million years in --release config
    another_crate::great_question()
});

// The `String` is built, stored in the `LazyLock`, and returned as `&String`.
let _ = &*DEEP_THOUGHT;
```

## Once

```rust
use std::sync::Once;

pub fn init_tracing() {
    static INIT_SUBSCRIBER: Once = Once::new();

    INIT_SUBSCRIBER.call_once(|| {
        let show_code_location = false;
        tracing_subscriber::fmt()
            .init();
    })
}
```

* `Once::call_once`で一度だけ処理を実行できる
