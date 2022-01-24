# Drop 

## Drop order

変数は最後に宣言されたものが最初にdropされる。  
理由は、最後の変数はそれより前の変数の参照を含められるので、最初に宣言された変数をdropしてしまうと  
一時的に無効な参照が生まれてしまうから。

```rust
let x1 = String::from("hello"); // <- drop second
let x2 = &x1;                   // <- drop first
```

struct, tuple, array等は、先頭から順にdropしていく。  
そのほうが直感的なのと、self referenceを許していないから。
