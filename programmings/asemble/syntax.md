# Assembly Syntax

IntelとAT&Tで違う

## Intel

* register prefixなし
* mov <dest> <source>
  * 内向きなので外から中と覚える
* メモリ演算は`[]`で囲む


## AT&T

* `%`がregister prefix
* `$`がimmediate prefix
* mov <source> <dest>
* `(%eax)` のかっこは `*(int *)EAX`のようにregisterの値をメモリアドレスとして参照するという意味
  * `0xc(%ebp)`はEBPに0xc(12)を加算してから参照する
    * `*(int *)((char *)EBP+0xc)`という感じ
* GNU アセンブラはAT&Tらしい
