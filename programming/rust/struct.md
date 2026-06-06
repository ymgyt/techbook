# struct

## 定数の定義

`impl`の中に`const`で定義する

```rust
struct MyStruct {
     x: i32
 }
  
 impl MyStruct {
     const MY_CONST: u32 = 8;
     
     pub fn my_func(&self) {
         println!("my_func called: {}", Self::MY_CONST);
     }
 }
 
 fn main() {
     println!("{}", MyStruct::MY_CONST);
     MyStruct{x: 1212}.my_func();
 }
```
