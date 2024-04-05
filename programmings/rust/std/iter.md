# std::iter

## closureでiteratorを作る

```rust
pub fn intervals(&self) -> impl Iterator<Item = TaskMetrics> {
    let latest = self.metrics.clone();
    let mut previous: Option<TaskMetrics> = None;

    std::iter::from_fn(move || {
        let latest: TaskMetrics = latest.metrics();
        let next = if let Some(previous) = previous {
            TaskMetrics {
                instrumented_count: latest
                    .instrumented_count
                    .wrapping_sub(previous.instrumented_count),
                dropped_count: latest.dropped_count.wrapping_sub(previous.dropped_count),
                // Construct metrics...
            }
        } else {
            latest
        };

        previous = Some(latest);

        Some(next)
    })
}
```

* closureで前回の状態を保持したiteratorを作れる
* `impl Iterator<Item = X>`のRPITで戻り値を定義することでclosureを返しやすくなっている
