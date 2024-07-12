# syn and quote

## `DeriveInput`

```rust
pub struct DeriveInput {
    // derive(Debug)
    pub attrs: Vec<Attribute>,
    // pub, pub(super)
    pub vis: Visibility,
    // struct Ident
    pub ident: Ident,
    // Example<T>,
    pub generics: Generics,
    // fieldの情報
    pub data: Data,
}
```

## `quote::ToTokens`

```rust
use proc_macro::TokenStream;
use quote::{quote, ToTokens};
use syn::{
    parse_macro_input, Data, DataStruct, DeriveInput, Field, Fields, FieldsNamed, Ident, Type,
};

struct StructField {
    name: Ident,
    ty: Type,
}

impl StructField {
    fn new(field: &Field) -> Self {
        Self {
            name: field.ident.as_ref().unwrap().clone(),
            ty: field.ty.clone(),
        }
    }
}

impl ToTokens for StructField {
    fn to_tokens(&self, tokens: &mut proc_macro2::TokenStream) {
        let n = &self.name;
        let t = &self.ty;
        quote!(pub #n: #t).to_tokens(tokens)
    }
}

#[proc_macro_attribute]
pub fn public(_attr: TokenStream, item: TokenStream) -> TokenStream {
    let ast = parse_macro_input!(item as DeriveInput);
    let name = ast.ident;
    let fields = match ast.data {
        Data::Struct(DataStruct {
            fields: Fields::Named(FieldsNamed { ref named, .. }),
            ..
        }) => named,
        _ => unimplemented!("only works for structs with name fields"),
    };

    let builder_fields = fields.iter().map(StructField::new);

    let public_version = quote! {
        pub struct #name {
            #(#builder_fields,)*
        }
    };

    public_version.into()
}
```

## `syn::Parse`

```rust
use proc_macro::TokenStream;
use quote::{quote, ToTokens};
use syn::{
    parse::{Parse, ParseStream},
    parse_macro_input,
    punctuated::Punctuated,
    token::Colon,
    Data, DataStruct, DeriveInput, Field, Fields, FieldsNamed, Ident, Type, Visibility,
};

struct StructField {
    name: Ident,
    ty: Ident,
}

impl StructField {
}

impl ToTokens for StructField {
    fn to_tokens(&self, tokens: &mut proc_macro2::TokenStream) {
        let n = &self.name;
        let t = &self.ty;
        quote!(pub #n: #t).to_tokens(tokens)
    }
}

impl Parse for StructField {
    fn parse(input: ParseStream) -> Result<Self, syn::Error> {
        let _vis: Result<Visibility, _> = input.parse();
        let list = Punctuated::<Ident, Colon>::parse_terminated(input).unwrap();

        Ok(StructField {
            name: list.first().unwrap().clone(),
            ty: list.last().unwrap().clone(),
        })
    }
}

#[proc_macro_attribute]
pub fn public(_attr: TokenStream, item: TokenStream) -> TokenStream {
    let ast = parse_macro_input!(item as DeriveInput);
    let name = ast.ident;
    let fields = match ast.data {
        Data::Struct(DataStruct {
            fields: Fields::Named(FieldsNamed { ref named, .. }),
            ..
        }) => named,
        _ => unimplemented!("only works for structs with name fields"),
    };

    let builder_fields = fields
        .iter()
        .map(|f| syn::parse2::<StructField>(f.to_token_stream()).unwrap());

    let public_version = quote! {
        pub struct #name {
            #(#builder_fields,)*
        }
    };

    public_version.into()
}
```
