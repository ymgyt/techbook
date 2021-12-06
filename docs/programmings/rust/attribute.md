# Attribute

## `#[repr()]`

型の内部表現についての指定をコンパイラに伝える。  
特定のアラインメントが必要、cと同じメモリレイアウト等。

### `#[repr(transparent)]`

定義しようとしている型はその内部の型と同じメモリレイアウトをもつ必要がある。  
newtype patternのようにひとつのfieldだけをもつ型で利用できる。
```rust
#[repr(transparent)]
struct UserID(String)
```

[参考](https://blog.cardina1.red/2020/12/24/defining-custom-slice-types/#defining-slice-types--repr-transparent)


## `#[must_use]`

FutureやResultのように関数の戻り値を呼び出し側が利用しなかった場合に警告をだす。

```rust
#[must_use]
fn check() -> bool { false }

// Violates
check();
```




## conditional compilation

`[cfg]`はRustのitemsの前に書ける。(function, impl, module, use)

```rust
// feature f1かf2が有効なら
#[cfg(any(feature = "f1", feature = "f2"))]

// mac
#[cfg(target_os = "macos")]

// miriにignoreを渡す
#[cfg_attr(miri, ignore)]

```

### `#[cfg(target_family = xxx)`

targetのOS。 macもunix familyに含まれる。
```rust
#[cfg(target_family = "unix")]
fn create_file() {}

#[cfg(target_family = "windows")]
fn create_file() {}
```

### `#[cfg(feature = "some-feature")`


crateのfeatureで制御できる。

## 参考

* [Rustでプラットフォーム依存の処理を書く](https://ryochack.hatenablog.com/entry/2018/10/14/112957)

## Crate Level Attribute

crate全体に影響する設定。

### `#![no_std]`

compilerがstdではなく、coreを使うようになる。

### `#![no_main]`

OSに依存する`main()`の前処理用のコードが生成されないようにする。

