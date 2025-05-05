# extern

* `extern "ABI" fn foo(i: 32)`
* Rustに関数のABIを伝える
  * callee-saved registerやregister, stackの使い方を指示している

```rust
extern "C" fn foo(i: i32);
```

```rust
#[repr(C)]
struct EfiBootServicesTable {
    _reserved0: [u64; 40],
    locate_protocol: extern "win64" fn(
        protocol: *const EfiGuid,
        registration: *const EfiVoid,
        interface: *mut *mut EfiVoid,
    ) -> EfiStatus,
}
```
