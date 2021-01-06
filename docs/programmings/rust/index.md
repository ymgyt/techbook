# Rust

* [attribute](attribute.md)

## Dynamically Sized Type (DST)

以下のTypeが代表的なDST。

* `dyn MyTrait` (trait object)
* `[T]`, `str` (slices)

DSTはcompile時にsizeやalignmentがわからないので、**behind a pointerでしか存在できない。**  
したがって、DSTはwide/fat pointerになる。(sliceならsize, trait objectならvtable)
