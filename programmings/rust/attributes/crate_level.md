# Crate Level Attribute

crate全体に影響する設定。

## `#![no_std]`

compilerがstdではなく、coreを使うようになる。

## `#![no_main]`

OSに依存する`main()`の前処理用のコードが生成されないようにする。

## `#![warn()]`

いれておくのがオススメされているもの

* missing_docs
* missing_debug_implementations

