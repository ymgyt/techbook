# function like macro

## Example

```rust
use proc_macro::TokenStream;
use quote::quote;
use syn::{parse_macro_input, DeriveInput};

#[proc_macro]
pub fn private(item: TokenStream) -> TokenStream {
    let ast = parse_macro_input!(item as DeriveInput);
    let name = ast.ident;

    quote! {
        struct #name { }
        impl #name { }
    }
    .into()
}
```

* `#[proc_macro]`をつける
  * macroの名前は関数名から決まる

* outputが引数のtoken streamを上書きする
  * この点はattribute macroと同じ

* なんでも渡せる
  * validなrustのcodeに限定されない
  * ここがattribute macroと違う点
