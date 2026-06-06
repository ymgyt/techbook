# Criterion

## Usage

まず`Cargo.toml`に以下を追加

```toml
[dev-dependencies]
criterion = "0.3"

[[bench]]
name = "combination"
harness = false
```

* nameは`benches/combination.rs`に対応する


次にbenchmarkを書く。  
`benches/combination.rs`に以下を記述。

```rust
use atcoder_lib::calc::combination::{count_combinations, count_combinations_iter};
use criterion::{black_box, criterion_group, criterion_main, BenchmarkId, Criterion};

fn bench_combinations(c: &mut Criterion) {
    let mut group = c.benchmark_group("Combinations");

    for &input in [10_usize, 30_usize, 50_usize].iter() {
        group.bench_with_input(BenchmarkId::new("Iter", input), &input, |b, &input| {
            b.iter(|| count_combinations_iter(input, 3))
        });
        group.bench_with_input(BenchmarkId::new("Fold", input), &input, |b, &input| {
            b.iter(|| count_combinations(input, 3))
        });
    }

    group.finish();
}

criterion_group!(benches, bench_combinations);
criterion_main!(benches);
```

`cargo bench`を実行する。  
`target/criterion/report.index.html`が生成されるので参照する。


## Memo

`back_box()`はcompilerのoptimizationの無効化用。
