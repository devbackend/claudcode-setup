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

```rust
#[derive(Debug, thiserror::Error)]
pub enum ServiceError {
    #[error("not found: {0}")]
    NotFound(String),
    #[error("database error")]
    Database(#[from] sqlx::Error),
}
```

## anyhow pattern

```rust
use anyhow::{Context, Result};

fn load_config(path: &Path) -> Result<Config> {
    let content = fs::read_to_string(path)
        .with_context(|| format!("failed to read {}", path.display()))?;
    Ok(toml::from_str(&content)?)
}
```
