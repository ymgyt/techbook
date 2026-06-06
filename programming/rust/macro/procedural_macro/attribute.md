# attribute macro

## Example

```rust
use proc_macro::TokenStream;
use quote::quote;
use syn::{parse_macro_input, DeriveInput};

#[proc_macro_attribute]
pub fn public(_attr: TokenStream, item: TokenStream) -> TokenStream {
    let _ast = parse_macro_input!(item as DeriveInput);
    let public_version = quote! {};

    public_version.into()
}
```

* `#[proc_macro_attribute]`をつける
* attribute macroの名前はannotateされる関数名(`public`)で決まる
  * `#[proc_macro_derive(Hello)]`のようなderiveとの違い

* derive macroは関数の戻り値がcodeに追加されるが、attributeはcodeを置き換える
  * もし空のTokenStreamを返したら、元のcodeが消える
