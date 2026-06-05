# Rust Error Handling

## Library vs Application

- **Libraries**: define domain-specific error types with `thiserror`
- **Applications**: use `anyhow` for ergonomic error propagation

## Rules

- Never use `.unwrap()` or `.expect()` in library code
- Use `.expect()` in application code only with a message explaining the invariant: `config.get("key").expect("key set in main")`
- Add context with `.context("what was being attempted")` or `.with_context(|| format!(...))`
- Use `?` everywhere — avoid `match` on `Result` unless branching on the error variant

## thiserror pattern

See `~/.claude/examples/rust-error-handling.rs`.

## anyhow pattern

See `~/.claude/examples/rust-error-handling.rs`.
