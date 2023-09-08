# pin

## `Pin`

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
  

## `Unpin`

* marker trait
  * implementing type can be removed safely from a `Pin`
  * self referenceを含んでいない型はmoveしても安全なので、`Pin`の保証が必要ない


## Projection

* `Pin<&mut Self>`から`Pin<&mut Field>`をえること
  * `Future`をfieldにもちwrapしている場合、poll時に必要になる
* Dropの実装等、はまりどころがあるので`pin_project`を利用する
