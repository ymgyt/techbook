# bindgen

* C言語のheader fileからrustを生成するツール
* clang(LLVM), libclangを利用している
  * マクロの処理ができる

```c
typedef void (*f_t)(int a);
struct Foo {
    f_t f;
};

extern void f(struct Foo *);

```

から以下のようなrustを生成

```rust
#[repr(C)]
#[derive(Copy, Clone, Debug)]
pub struct Foo {
    pub f: ::std::option::Option<extern "C" fn(a: ::std::os::raw::c_int)>,
}

extern "C" {
    pub fn f(arg1: *mut Foo);
}
```

* defaultでは`std::os::raw::c_int`を使う
* `core::ffi`を使うように指定もできる
