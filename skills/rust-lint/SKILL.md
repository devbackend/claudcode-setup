---
name: rust-lint
description: Run cargo clippy with all-targets and deny warnings, plus cargo fmt check.
---

# Rust Lint

Run:

```bash
cargo clippy --all-targets --fix --allow-dirty -- -D warnings
cargo fmt
```

- If it passes: report "lint passed".
- If there are unfixable clippy issues: show the output, fix manually, then re-run until clean.

Do not mark the task complete until both clippy and fmt pass.
