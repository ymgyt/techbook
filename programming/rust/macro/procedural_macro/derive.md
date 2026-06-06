# Derive macro

```rust
use proc_macro::TokenStream;
use quote::quote;
use syn::DeriveInput;

#[proc_macro_derive(Hello, attributes(rename,foo))]
pub fn anything(item: TokenStream) -> TokenStream {
    let ast = match syn::parse::<DeriveInput>(item) {
        Ok(input) => input,
        Err(err) => return TokenStream::from(err.to_compile_error()),
    };
    let name = ast.ident;
    let add_hello_world = quote! {
        impl #name {
            fn hello_world(&self) {
                println!("Hello World")
            }
        }
    };
    add_hello_world.into()
}
```

```rust
#[derive(mycrate::Hello)]
struct Example {}
```

* `proc_macro_derive(DeriveName)` annotationを付与する
  * 関数名はなんでもよい
* `syn::DeriveInput`にparseする
* attributesは`attributes(field)`で指定する
  * derive macro helper attributesと呼ばれているらしい
