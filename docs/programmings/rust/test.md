# Test

## Mechanisms

* `cargo test --lib`を実行すると
  * cargoは`--test` flagをrustcに渡すだけ
  * rustcはtest binaryを生成する
    * `cfg(test)`が有効になる
    * `#[test]`をつけた関数を実行するtest harness(main)を生成する

## Integration test

* `tests/`以下のfileはintegration testとして認識される
  * fileごとにtest harnessが生成される
  * directoryは対象にならないので、test organize用の処理書きたかったらここ。
* crateは`cfg(test)`がない状態でbuildされる
* 

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
