# std::sync::atomic::fench

## fence

**Release fenceに後続する任意のstoreが、Acquire fenchに先行する任意のloadによって観測された場合、Release fenchとAcquire fenchの間にhappens-before relationshipsが成り立つ**

本質的には、Release storeとAcquire loadはそれぞれ前後にfench命令を追加した場合と同義になる。(orderはrelaxed)

例えば、

```rust
// a.store(Release)は以下と同義
fence(Relase);
a.store(Relaxed);
```

と
```rust
// a.load(Acquire)は以下と同義
a.load(Relaxed);
fence(Acquire);
```

があると、aのloadでhappens-beforeが成り立つということ。

* **fenchは1つのatomic変数に結び付けられていない**
* **fenchは複数のatomic変数を同時に扱える**
* **fenchとatomic操作は直接隣り合っている必要はない**

```rust
// thread 1
fence(Release);
A.store(Relaxed);
B.store(Relaxed);
C.store(Relaxed);
```

```rust
// thread 2
A.load(Relaxed);
B.load(Relaxed);
C.load(Relaxed);
fence(Acquire);
```

この例では、thread 2のloadがthread 1のstoreの値を読み込んだ場合、thread 1のrelease fenchがthread 2のacquire fenchに対して先行発生する(happen before)

fenceと制御フローを組み合わせることもできる

```rust
let p = PTR.load(Relaxed);
if p.is_null() {
  // do nothing
} else {
  fence(Acquire);
  // do something...
}
```

上記では、pointerがnullの場合にacquire orderを利用することを避けられる