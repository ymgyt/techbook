# insta

* snapshot testを実施するためのtool
  * snapshotとはtest時のassertする正解の値にtest対象自体の結果を利用するtest
  * つまりfunc_aの時点t1の出力結果がt1以降のfunc_aのtestのassert値となる

* 自分でsnapshot testを行おうと思うとsnapshotの保存(serialize,永続化)と更新を管理する必要がある。instaはこれを提供
* 各種`assert_`関数は結果のserialize方法を指定するものと思われるので本質的にやっていることは同じ

## Install

```toml
[dev-dependencies]
insta = "1.13.0"
```

`cargo install cargo-insta`


## 使い方

```shell
cargo test
cargo insta review
```

* instaが提供するassert関数にtest対象の出力結果を渡すと自動的にsnapshotと比較される
* 新規追加する場合はtestは失敗する
* 新規追加かsnapshotと出力結果が異なる場合、snapshot候補のfileが生成される
  * `.new`拡張子をもつ
* snapshot候補をsnapshotに採用するために`cargo insta review`が必要
* `cargo insta test --unreferenced=delete`でつかわれていないsnapshotを削除
  * `auto`だとCIでは失敗、localでは削除にしてくれる

## Assertion

### Settings

```rust
insta::with_settings!({sort_maps => true}, {
    // run snapshot test here
    insta::assert_debug_snapshot!("foo");
});
```

* `set_sort_maps(true)`と`sort_maps => true`は同じらしい
* redactionも設定できるらしいが調べきれていない

以下のコードと同じ

```rust
let mut settings = Settings::clone_current();
settings.set_sort_maps(true);
settings.bind(|| {
    // run snapshot test here
});
```

### `Vec`のorderを無視したい

```rust
    insta::assert_json_snapshot!(
        response.items,
        {
            "[].tag_ids" => insta::sorted_redaction(),
            "[].user_ids" => insta::sorted_redaction()
        }
    );
```

* assert_snapshotの第二引数に、無視したいfieldのpathを渡す。
  * `Vec<T>`の場合は`T`にあてるために、`[]`を書いている
* `insta::sorted_redaction()`を使うとsnapshotにする前にinsta側でsortしてくれる


## わかっていないこと

* `cargo test`と`cargo insta test`


