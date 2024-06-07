# insta

* snapshot testを実施するためのtool
  * snapshotとはtest時のassertする正解の値にtest対象自体の結果を利用するtest
  * つまりfunc_aの時点t1の出力結果がt1以降のfunc_aのtestのassert値となる

* 自分でsnapshot testを行おうと思うとsnapshotの保存(serialize,永続化)と更新を管理する必要がある。instaはこれを提供
* 各種`assert_`関数は結果のserialize方法を指定するものと思われるので本質的にやっていることは同じ

## Install

```toml
[dev-dependencies]
insta = { version = "1.13.0", features = ["yaml"] }

[profile.dev.package]
insta.opt-level = 3
```

`cargo install cargo-insta`

* devでもopt-levelをあげると良いとdocにあった 
* yaml featuresを使うと`assert_yaml_snapshot!`

## 使い方

```shell
cargo test
# or cargo insta test
cargo insta review
```

* instaが提供するassert関数にtest対象の出力結果を渡すと自動的にsnapshotと比較される
* 新規追加する場合はtestは失敗する
* 新規追加かsnapshotと出力結果が異なる場合、snapshot候補のfileが生成される
  * `.new`拡張子をもつ
* snapshot候補をsnapshotに採用するために`cargo insta review`が必要
* `cargo insta test --unreferenced=delete`でつかわれていないsnapshotを削除
  * `auto`だとCIでは失敗、localでは削除にしてくれる
  * `reject`,`warn`もある
  * `cargo test`と`cargo insta test`の違いは1 functionの中に複数snapshotがある場合にまとめてくれる

* `export CI=true`を設定すると振る舞いが変わる
  * nixでどう設定すべきか
  * review用のnew snapshotが作られなくなる

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

### Inline

snapshotをsrc codeに保持できる

```rust
fn split_words(s: &str) -> Vec<&str> {
    s.split_whitespace().collect()
}

#[test]
fn test_split_words() {
    let words = split_words("hello from the other side");
    insta::assert_yaml_snapshot!(words, @"");
}
```

* 実行すると `@""` 以降にsnapshotが保存される

### snapshot name and debug expression

```rust
#[test]
fn test_something() {
    assert_snapshot!("first_snapshot", "first value", "debug_review_context");
    assert_snapshot!("second_snapshot", "second value");
}
```

* 第1引数にsnapshotの名前を渡せる
* 第3引数に渡したdebug expressionをreviewで表示できる


### Add Context to review  UI

素の状態だとcargo insta reviewのreviewでacceptしていいかsrcと相談する必要がある。以下のようにすると、review UIに情報を追加できる

```rust
insta::with_settings!({
    info => &ctx, // structを渡せる
    description => "snapshot description here"
    omit_expression => true // わかってない
}, {
    insta::assert_snapshot!(template.render(ctx));
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


### Redaction

* uuidやtimestamp等の一部のdataを無視(置換)できる
* feature `redactions`が必要

```rust
insta::with_settings!({
    description => " log 1 record",
}, {
    insta::assert_yaml_snapshot!("layer_test_log_1_record", record, {
        ".observedTimeUnixNano" => "[OBSERVED_TIME_UNIX_NANO]",
        ".attributes[0].value" => "[SOURCE_CODE_LOCATION]",
    });
});
```

* 第三引数の`{ ... }`に書く
* `selector => "replaced value"`を書く
  * selectorはserialize後のpathであてる

