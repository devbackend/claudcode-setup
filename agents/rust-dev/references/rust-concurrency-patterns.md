# Rust Concurrency Patterns

## Async

- Use `tokio` as the async runtime unless the project specifies otherwise
- Prefer `async/await` over manual `Future` implementations
- Document `Send + Sync` bounds clearly on public async functions

## CPU-bound parallelism

Use `rayon` for data parallelism — not `tokio` tasks. See `~/.claude/examples/rust-concurrency.rs`.

## Shared state

- Prefer channels (`tokio::sync::mpsc`, `crossbeam`) over shared mutable state
- Use `Arc<RwLock<T>>` for read-heavy shared data, `Arc<Mutex<T>>` for write-heavy
- **Never** use `std::sync::Mutex` inside async code — use `tokio::sync::Mutex`

## Common patterns

See `~/.claude/examples/rust-concurrency.rs`.
