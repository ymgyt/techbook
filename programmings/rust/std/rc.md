# rc

## Rc

* Boxをcloneするとメモリに新しいinstanceが生成されるが`Rc
  `の場合は、参照カウントをincrementするだけ
  * 同じメモリを参照している点を捉えて、所有権semanticsとしては共同所有を表現する

```rust
use std::rc::Rc;

fn main() {
    let a = Rc::new([1, 2, 3]);
    let b = a.clone();
    assert_eq!(a.as_ptr(), b.as_ptr());
}
```

* Drop時に参照counterをdecrementする。
  * 0になった際にDropされる
* Sendしたければ、`std::sync::Arc`を利用する