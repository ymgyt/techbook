# procedural macro setup

* 専用のlib crateが必要

Cargo.toml
```toml
[package]
name = "hello_world_macro"

[lib]
proc_macro = true

[dependencies]
quote = "1.0.36"
syn = "2.0.70"
```

lib.rs

```rust
use proc_macro::TokenStream;
use quote::quote;

#[proc_macro_derive(Hello)]
pub fn anything(_item: TokenStream) -> TokenStream {
    let add_hello_world = quote! {};
    add_hello_world.into()
}
```
