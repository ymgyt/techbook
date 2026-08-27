# pin-init

* object(struct)を最終配置先で初期化する
* 初期化後そのアドレスから動かさない

## 課題

Cではまず未初期化のmemory(buffer)を確保して、初期化処理に渡す

```c
void buf_init(struct buf *p, u8 val)
{
    memset(p->data, val, 1024 * 1024);
}
```

Rustでは一度値を作って、return by valueする

```rust
impl Buf {
    fn new(val: u8) -> Buf {
        Buf {
            data: [val; 1024 * 1024],
        }
    }
}
```

* kernel stackは小さいので、一時的にも1MiBもstackを使いたくない

ただし、これは定義できない。`&mut Buf`の時点で有効な値でなければいけない。
`&mut Buf` は未初期化のBufを初期化するためのpointer型ではない

```rust
impl Buf {
    fn init(p: &mut Buf, val: u8) { /* ... */ }
}
```



以下にように、heapに未初期化(MybeUninit)を確保して、Tに初期化させたのちPinする

## Mental Model

以下の型を初期化したい

```rust
struct SelfRef {
    value: u32,
    value_ptr: *const u32,
    _pin: PhantomPinned,
}
```

メモリ確保と制御フローを以下のように実装する

```rust
unsafe fn pin_box_with<T>(
    init: impl FnOnce(*mut T),
) -> Pin<Box<T>> {
    // 1. Tを置ける未初期化ヒープ領域を確保する
    let mut slot: Box<MaybeUninit<T>> = Box::new_uninit();

    // 2. 最終配置先のアドレス
    let ptr: *mut T = slot.as_mut_ptr();

    // 3. その場所で直接Tを初期化する
    init(ptr);

    // 4. Tが完成したと宣言する
    // ここから、initが型を完全な状態にするという契約が導かれる
    let initialized: Box<T> = unsafe {
        slot.assume_init()
    };

    // 5. 以後、ヒープ上のTを動かさないと宣言する
    unsafe {
        Pin::new_unchecked(initialized)
    }
}
```

利用側

```rust
let value: Pin<Box<SelfRef>> = unsafe {
    pin_box_with(|slot| {
        unsafe {
            // valueを最終配置先に直接作る
            addr_of_mut!((*slot).value).write(42);

            // 最終配置されたvalueのアドレスを取得する
            let value_ptr = addr_of!((*slot).value);

            // value_ptrフィールドへ書く
            addr_of_mut!((*slot).value_ptr).write(value_ptr);

            // 最後のフィールドも初期化する
            addr_of_mut!((*slot)._pin).write(PhantomPinned);
        }
    })
};
```

メモリ状況

```text
ヒープ 0x8000 を確保

0x8000 SelfRef
  value     : 未初期化
  value_ptr : 未初期化
  _pin      : 未初期化

             ↓ init(ptr)

0x8000 SelfRef
  value     : 42              たとえば0x8000
  value_ptr : 0x8000
  _pin      : PhantomPinned

             ↓ Pin<Box<SelfRef>>
```
以後、0x8000のSelfRefはmoveしない

エラーが発生した場合は、初期化したfieldを正しく破棄する必要がある。

ここから、未初期化の `*mut T`を渡されたら、成功時には完全なTを残し、失敗時は綺麗にする責務を表現する、`PintInit<T,E>` が導かれる

## References

* [Initialization in Rust with pin-init](https://lpc.events/event/19/contributions/2018/attachments/1769/3837/handout.pdf)
  * LPC2025 Rust sectionのスライド
* [Pinning in Rust](https://kangrejos.com/Pinning%20in%20Rust.pdf)
* [For levels of in-place Initialization](https://blog.yoshuawuyts.com/four-levels-of-in-place-initialization/)
