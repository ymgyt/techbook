# pin_project

## Example

```rust
#[pin_project::pin_project] // This generates a `project` method
pub struct TimedWrapper<Fut: Future> {
	// For each field, we need to choose whether `project` returns an
	// unpinned (&mut T) or pinned (Pin<&mut T>) reference to the field.
	// By default, it assumes unpinned:
	start: Option<Instant>,
	// Opt into pinned references with this attribute:
	#[pin]
	future: Fut,
}

impl<Fut: Future> Future for TimedWrapper<Fut> {
    // This future will output a pair of values:
    // 1. The value from the inner future
    // 2. How long it took for the inner future to resolve
    type Output = (Fut::Output, Duration);

    fn poll(self: Pin<&mut Self>, cx: &mut Context) -> Poll<Self::Output> {
        // This returns a type with all the same fields, with all the same types,
        // except that the fields defined with #[pin] will be pinned.
        let mut this = self.project();

        // Call the inner poll, measuring how long it took.
        let start = this.start.get_or_insert_with(Instant::now);
        let inner_poll = this.future.as_mut().poll(cx);
        let elapsed = start.elapsed();

        match inner_poll {
            // The inner future needs more time, so this future needs more time too
            Poll::Pending => Poll::Pending,
            // Success!
            Poll::Ready(output) => Poll::Ready((output, elapsed)),
        }
    }
}
```

https://blog.cloudflare.com/pin-and-unpin-in-rust/
