# Test

## Mechanisms

* `cargo test --lib`を実行すると
  * cargoは`--test` flagをrustcに渡すだけ
  * rustcはtest binaryを生成する
    * `cfg(test)`が有効になる
    * `#[test]`をつけた関数を実行するtest harness(main)を生成する

## Integration test

* `tests/`以下のfileはintegration testとして認識される
  * fileごとにtest harness(binary)が生成される
  * directoryは対象にならないので、test organize用の処理書きたかったらここ。
* crateは`cfg(test)`がない状態でbuildされる
* `tests/fixtures/main.rs`のように`main.rs`を定義すると独立したtest binaryが作成される
  * `#[test]`は書かないと実行されない

### `#[ignore]`

```rust
#[test]
#[ignore]
fn case1() {
   assert!(true); 
}
```

* 付与すると通常のtest実行ではskipされる
* `cargo test -- --ignored`のようにflagを付与すると実行される

## `cargo test`

* test時のstdoutを出力する。 `cargo test -- --nocapture`

### f64を`assert_eq`する

```rust
pub fn calc(input: f64) -> f64 {
    0.0
}

#[cfg(test)]
mod tests {
    use super::*;
    use assert_approx_eq::assert_approx_eq;

    #[test]
    fn calc_test() {
        let cases = vec![
            1.0,
            2.0,
        ];
        // 許容する誤差。
        let eps = 1e-6f64;

        for case in cases {
            assert_approx_eq!(input(case), expect, eps);
        }
    }
}
```

## Doctests

* 自動的に`fn main()`の中に書かれる。
  * opt outして自分で書くこともできる。
* `/// #`のように`#`つけると、doctestには含まれるが、生成されるdocumentationには含まれない。

```rust
/// # Examples
///
/// ```
/// let x = 5;
/// ```
```

* triple backtickで囲むとdoctestの対象になる

### ignore

```text
/// ```ignore
/// fn foo() {
/// ```
```

* `ignore`をつけるとdoctestの範囲外にできる
