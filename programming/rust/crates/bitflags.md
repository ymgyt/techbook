# bitflags

```rust
use bitflags::bitflags;

// 定義
bitflags! {
    pub(super) struct Should: u64 {
        const Render = 1 << 0;
        const Quit = 1 << 1;

    }
}

pub struct Application {
    flags: Should,
}

impl Application {
  fn example(&mut self) {
    // Render flagをたてる
    self.flags.insert(Should::Render);

    // 判定
    if self.flags.contains(Should::Render) {
      // flagを無効
      self.flags.remove(Should::Render);
    }
  }
}
```
