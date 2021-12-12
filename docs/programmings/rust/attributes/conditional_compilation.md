# Conditional Compilation

`[cfg]`はRustのitemsの前に書ける。(function, impl, module, use)

```rust
// feature f1かf2が有効なら
#[cfg(any(feature = "f1", feature = "f2"))]

// mac
#[cfg(target_os = "macos")]

// miriにignoreを渡す
#[cfg_attr(miri, ignore)]

```

## `#[cfg(target_family = xxx)`

targetのOS。 macもunix familyに含まれるので、`windows`or`unix`になる
```rust
#[cfg(target_family = "unix")]
#[cfg(unix)] // 同じ意味
fn create_file() {}

#[cfg(target_family = "windows")]
#[cfg(windows)] // 同じ意味
fn create_file() {}
```

## `[cfg(target_os = xxx)]`

windows, macos, linuxを指定できる。target_familyより細かく指定したいときはこっち?

## `#[cfg(feature = "some-feature")`

crateのfeatureで制御できる。

## `#[cfg_attr()]`

条件(predicate)がtrueのとき、attributeとして展開される。

```rust
#[cfg_attr(feature = "magic", sparkles, crackles)]
fn bewitched() {}

// When the `magic` feature flag is enabled, the above will expand to:
#[sparkles]
#[crackles]
fn bewitched() {}
```

## 参考

* [Rustでプラットフォーム依存の処理を書く](https://ryochack.hatenablog.com/entry/2018/10/14/112957)
