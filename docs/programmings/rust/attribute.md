# Attribute

## `#[repr()]`

型の内部表現についての指定をコンパイラに伝える。  
特定のアラインメントが必要、cと同じメモリレイアウト等。

### `#[repr(transparent)]`

定義しようとしている型はその内部の型と同じメモリレイアウトをもつ必要がある。

[参考](https://blog.cardina1.red/2020/12/24/defining-custom-slice-types/#defining-slice-types--repr-transparent)


## `#[must_use]`

FutureやResultのように関数の戻り値を呼び出し側が利用しなかった場合に警告をだす。

```rust
#[must_use]
fn check() -> bool { false }

// Violates
check();
```
