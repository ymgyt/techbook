# Trait Object

* `dyn` + Traitsで定義される
    * `dyn Trait + Send + Sync + 'static`のように最初のtrait以降にはauto traitだけを書ける
    * lifetimeも書ける
* 実態はその型のinstanceへのpointerとvtableへのpointerからなるwide pointer
* `!Sized`なので、Sizedが要求される場合は、`Box<dyn T>`, `&dyn T`, `&mut dyn T`のように表現される。
* traitのmethodに`where Self: Sized`と書くと、そのtraitはtrait objectからは呼ばれず、必ずconcrete typeに呼ばれることを強制できる。


## Object Safety

* traitのmethodごとにobject-safeか判定される
* traitのmethodに`Self: Sized`をつけると、そのmethodをtrait-safeにできるが、trait objectから呼び出せなくなる。
  * なので、trait自体のobject-safeを維持しつつ、object-safeに違反してしまうようなmethodにこれをつける。

https://github.com/rust-lang/rfcs/blob/master/text/0255-object-safety.md

以下のいずれかを満たせばmethodはobject safe
* require `Self : Sized`; or,
* meet all of the following conditions:
    * must not have any type parameters; and,
    * must have a receiver that has type `Self` or which dereferences to the `Self` type;
        - for now, this means `self`, `&self`, `&mut self`, or `self: Box<Self>`,
          but eventually this should be extended to custom types like
          `self: Rc<Self>` and so forth.
    * must not use `Self` (in the future, where we allow arbitrary types
      for the receiver, `Self` may only be used for the type of the
      receiver and only where we allow `Sized?` types).

traitがobject-safeになるためには

* all of its methods are object-safe; and,
* the trait does not require that Self : Sized

## Downcasting

* Downcasting is the process of taking an item of one type and casting it to a more specific type。

