# Trait Object

* `dyn` + Traitsで定義される
    * `dyn Trait + Send + Sync + 'static`のように最初のtrait以降にはauto traitだけを書ける
    * lifetimeも書ける
* 実態はその型のinstanceへのpointerとvtableへのpointerからなるwide pointer
* `!Sized`なので、Sizedが要求される場合は、`Box<dyn T>`, `&dyn T`, `&mut dyn T`のように表現される。
* traitのmethodに`where Self: Sized`と書くと、そのtraitはtrait objectからは呼ばれず、必ずconcrete typeに呼ばれることを強制できる。


## Object Safety

全てのtraitをtrait objectとして扱えるわけではなく、以下の条件を満たすtraitだけがtrait objectとして扱える

* The return type is not `Self`
* There are no generic type parameters

## Downcasting

* Downcasting is the process of taking an item of one type and casting it to a more specific type。

