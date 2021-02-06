# Rust

* [attribute](attribute.md)
* [control_flow](control_flow.md)
* [test](test.md)
* [tokio](tokio.md)

## Rules

Rust特有のruleについて。

* **if you're allowed to mutate or move a value, you are guaranteed to be the only one with access to it.**  
  だから`Arc`とかも一度cloneしてからthreadに渡すみたいな形になる。

## Dynamically Sized Type (DST)

以下のTypeが代表的なDST。

* `dyn MyTrait` (trait object)
* `[T]`, `str` (slices)

DSTはcompile時にsizeやalignmentがわからないので、**behind a pointerでしか存在できない。**  
したがって、DSTはwide/fat pointerになる。(sliceならsize, trait objectならvtable)

## Variance

**set of rules governing how subtyping should compose. variance defines situations where subtyping should be disabled.**

### Lifetimes

Lifetimesとは単なるregions of code. regionsはcontains(outlives)という関係でpartially orderできる。 

`'a: 'b`は`'a`は`'b`をoutliveする、includeしているとよむ。少なくとも`'b`が存在している限りは`'a`も存在していることを保証している。


## `std::marker::PhantomData`

runtime時にはメモリ割り当てをもたず、static analysisのためだけの型。

## `CopyとClone`

`Copy`は`Clone`の実装が単なるメモリのbitをcopyするだけの特殊なケースといえる。


## `Send`と`Sync`

型`T`が別のthreadに安全に渡せるなら`Send`、`&T`が`Send`なら`T`は`Sync`。

## Atomic

atomicなaccessはcompilerとhardwareにprogramがmulti-threadedであることを伝えるる。  
compilerとhardwareにできないことを伝えることになる。  
compilerには命令の並び替えに関して、hardware(CPU)では書き込みが他のthreadにどのように伝播されるかに関係する。
