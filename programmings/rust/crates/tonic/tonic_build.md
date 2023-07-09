# tonic_build

* protobufからgRPCのrustのcodeを生成してくれる

## `build.rs`

project rootに`build.rs`を置く。

```rust
fn main() {
    tonic_build::configure()
        // Client用codeを生成するかどうか
        .build_client(true) 
        // packageに該当するclient code全体に適用するcfg
        .client_mod_attribute("recommendation", "#[cfg(feature = \"client\")]")
        // Server用codeを生成するかどうか
        .build_server(true)
        // protoのmessageに該当する型のderiveをかける
        .type_attribute("Project", "#[derive(::serde::Serialize)]")
        // 生成されるrustのoutput先
        .out_dir("src/grpc")
        // 生成対象のprotoのpath. 第二引数なんだっけ
        .compile(&["proto/recommendation_gateway.proto"], &["proto"])
        .unwrap();

    // When running cargo fmt --check on CI, a rebuild is performed and the code is re-generated with no fmt applied, which is considered a violation.
    // This cannot be avoided even if the code with fmt applied is committed.
    std::process::Command::new("cargo")
        .args(&["fmt", "--", "src/grpc/recommendation.rs"])
        .output()
        .unwrap();
}
```

* build.rsはCIでのtestやlint時にも走るので、そのタイミングで生成されたコードにはfmtが適用されておらず、lintにひっかかるのでここで適用している。
