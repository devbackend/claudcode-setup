# Rust Concurrency Patterns

## Async

- Use `tokio` as the async runtime unless the project specifies otherwise
- Prefer `async/await` over manual `Future` implementations
- Document `Send + Sync` bounds clearly on public async functions

## CPU-bound parallelism

Use `rayon` for data parallelism — not `tokio` tasks:

```rust
use rayon::prelude::*;
let sum: u64 = data.par_iter().map(|x| x * x).sum();
```

## Shared state

- Prefer channels (`tokio::sync::mpsc`, `crossbeam`) over shared mutable state
- Use `Arc<RwLock<T>>` for read-heavy shared data, `Arc<Mutex<T>>` for write-heavy
- **Never** use `std::sync::Mutex` inside async code — use `tokio::sync::Mutex`

## Common patterns

```rust
// Fan-out with JoinSet
let mut set = tokio::task::JoinSet::new();
for item in items {
    set.spawn(async move { process(item).await });
}
while let Some(result) = set.join_next().await {
    handle(result?)?;
}
```

```rust
// Bounded channel for backpressure
let (tx, rx) = tokio::sync::mpsc::channel(32);
```
