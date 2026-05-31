# Rust Core Rules

## Style & Idioms

- Use `rustfmt`-compatible formatting at all times
- Prefer iterators and functional chains over manual loops when clarity is maintained
- Use `?` operator for error propagation — never ignore `Result` or `Option`
- Leverage `impl Trait` and generics to avoid unnecessary dynamic dispatch (`dyn Trait`)
- Use newtype patterns to enforce invariants at compile time
- Prefer `enum` over stringly-typed values or boolean flags
- Use `derive` macros (`Debug`, `Clone`, `PartialEq`, etc.) where appropriate
- Apply `#[must_use]` on functions whose return values should not be ignored
- Address all `clippy` warnings; use `#[allow(...)]` only with justification comment

## Safety

- Minimize `unsafe` blocks — isolate and document all unsafe code with invariant comments
- Encapsulate `unsafe` behind safe abstractions
- Never `transmute` without exhaustive justification

All code must pass:
```
cargo build --all-targets
cargo test
cargo clippy --all-targets -- -D warnings
cargo fmt --check
```
