# pin

## `Pin`

* `Pin<T>` において、Tが`Unpin`を実装していない限り、`&mut T`をsafeな方法では取得できないようする型
  * `&mut T`が取得できなければ、Tのアドレスが固定できるという前提(当然、Tも)
* wrapper typeで、wrapped typeがmoveされるのを防ぐ
* メンタルモデルとしては、pointer型(`Box`,`&`, `&mut`,...)にpointee(指しているデータ)がmoveしない(メモリ上のアドレスがかわらない)という保証を付け加える型。
 
* `Pin<P>`で、Pにはpointerが使われる。`Pin<MyType>`みたいには使われない。
  * `Pin<MyType>`はそれ自身をmoveすればself-referenceを壊せる
    * `Pin<Box<MyType>>`
    * `Pin<Rc<MyType>>`
    * `Pin<&mut MyType>`
  * pointer型の`Deref`,`DerefMut`, `Drop`にもmoveさせない実装をしてもらいたい

* `Pin`の問題意識は、`Pin`自身がmoveしてもreferentがmoveしないこと
  * 一番簡単に実現するには、referentをheapに置くこと。`Box::pin()`はこのためにある
* 
* 対象の型(大体はFuture)が`Unpin`なら、`Pin::new(&mut future)`すればよいだけ

### Stackへのpin

* stackにpin止めするには、shadowingを利用する

```rust
// (1) 変数xを定義
let mut x = Object::new();
// (2) xへの参照をxとして定義
let mut x = &mut x;
```

### Heapへのpin

* `Box::pin()`を利用する
  * `Arc`,`Rc`も同様

* `Pin<Box<P>>`
  * BoxでもPが動かないことが保障できるが、`&mut P`がとれるので、`mem::replace`ができてしまう

## `Unpin`

* marker trait
  * auto trait
  * implementing type can be removed safely from a `Pin`
  * self referenceを含んでいない型はmoveしても安全なので、`Pin`の保証が必要ない

`Unpin`のopt-out(`!Unpin`)
```rust
struct SelfReferential {
  self_ptr: *constt Self,
  // optout Unpin
  _pin: core::marker::PhantomPinned,
}
```


## Projection

* `Pin<&mut Self>`から`Pin<&mut Field>`をえること
  * `Future`をfieldにもちwrapしている場合、poll時に必要になる
* Dropの実装等、はまりどころがあるので`pin_project`を利用する


## そもそもmoveとは

```rust

#[derive(Default)]
struct AddrTracker(Option<usize>);

impl AddrTracker {
    // If we haven't checked the addr of self yet, store the current
    // address. If we have, confirm that the current address is the same
    // as it was last time, or else panic.
    fn check_for_move(&mut self) {
        let current_addr = self as *mut Self as usize;
        match self.0 {
            None => self.0 = Some(current_addr),
            Some(prev_addr) => assert_eq!(prev_addr, current_addr),
        }
    }
}

// Create a tracker and store the initial address
let mut tracker = AddrTracker::default();
tracker.check_for_move();

// Here we shadow the variable. This carries a semantic move, and may therefore also
// come with a mechanical memory *move*
let mut tracker = tracker;

// May panic!
tracker.check_for_move();```
```
