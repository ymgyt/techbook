# operator

https://doc.rust-lang.org/reference/expressions/operator-expr.html#the-dereference-operator

## dereference operator `*`

* non-pointer type(`&`とか`*const`以外)に適用した場合
  * `*x` -> `*std::ops::Deref::deref(&x)`
  * `*x` -> `*std::ops::DerefMut::deref_mut(&mut x)`

## question mark operator

* `Result`に適用した場合
  * `Ok(x)`  -> `x`
  * `Err(e)` -> `return Err(From::from(e))`

* `Option`に適用した場合
  * `Some(x) `-> `x`
  * `None `   -> `return None`
