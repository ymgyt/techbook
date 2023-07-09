# 競技プログラミング関連のメモ

## 問題の考え方



## 二分探索

単調増加な配列において、条件を満たす要素と満たさない要素の境界が1つの場合に利用できる。  
ok,とngの変数で管理する場合  
* ok: 条件を満たすもっとも大きい要素を指す
* ng: 条件を満たさないもっとも小さい要素を指す

というように考えるとわかりやすい。

```rust
fn main() {
  let (ok, ng) = (-1, 1001); # 初期値は条件を満たす、満たさないに基づく
  let is_ok = |n| -> bool {
    n <= 50 # ここでは50を探している == 50以下が条件を満たす要素
  }

  while 1 < ng - ok { # okとngが並んだら終了
    let mid = (ok+ng) / 2;
    if is_ok(mid) {
      ok = mid
    } else {
      ng = mid
    }
  }

  println!("{ok}") # 答えは常にokの要素
}
```

## PriorityQueue

Heapとも。  
最大値(ないし最小値)を常にrootに保持する木。  
最大値のpop, 取得において木の再構成をともなうがlogNで完了するデータ構造。  
rustでは`std::collections::BinaryHeap`  
実装では配列を使って表現でき、木はあくまで論理上のデータ構造。

```rust
#[derive(PartialEq, Eq)]
struct Move {
    to: usize,
    cost: usize,
}

impl Ord for Move {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.cost.cmp(&other.cost)
    }
}

impl PartialOrd for Move {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cost.cmp(&other.cost))
    }
}

fn main() {
  let mut queue = std::collections::BinaryHeap::new();

  queue.push(std::cmp::Reverse(Move { to: 1, cost: 0}));
}
```

* `Ord`を実装すればstructでも要素にできる
* Defaultでは最大値が`pop()`で返るので、`Reverse`でwrapして最小値にできる

