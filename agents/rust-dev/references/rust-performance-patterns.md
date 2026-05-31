# Rust Performance Patterns

## Allocations

- Prefer stack allocation; use heap only when necessary
- Use `Cow<'_, T>` to avoid cloning when the borrowed case is common
- Use `SmallVec` or `ArrayVec` for small, bounded collections
- Prefer `&str` over `String` in function parameters
- Use `Arc<T>` over `Rc<T>` for thread-safe ref counting; avoid cloning `Arc` in hot paths

## String & collection efficiency

- Avoid `format!` / `to_string()` inside hot loops — pre-allocate or use `write!` into a buffer
- Pre-size collections: `Vec::with_capacity(n)`, `HashMap::with_capacity(n)`
- Use `ahash` or `rustc-hash` instead of `std` hasher for non-crypto maps

## Cache locality

- Prefer `Vec<T>` (contiguous memory) over linked structures
- Use struct-of-arrays (SoA) layout for hot data processed in tight loops
- Keep hot fields at the start of structs

## Inlining

- Apply `#[inline]` on small, frequently-called functions on hot paths
- Profile before applying `#[inline(always)]` — it can hurt icache

## Profiling

Profile before optimising. Use `cargo flamegraph` or `perf` to identify actual hot paths — never optimise by intuition alone.
