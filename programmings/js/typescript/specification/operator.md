# Operator

## `==`と`===`

* 原則`===`を使う。
  * `==`は暗黙の型変換をかましてくるので使わない
  * ただし、`x == null`は`x === null || x === undefined`と結果が一致するので使う場合がある

## `!!`

* `!`は式をbooleanにしたうえで結果を反転させる
* `!(!x)`と評価される。
  * `!!""`は空文字がfalseとなり2回反転させるのでfalse。空文字チェックができる。

## `??`

* `x ?? y`はxがnullまたはundefinedのときにyを返す
