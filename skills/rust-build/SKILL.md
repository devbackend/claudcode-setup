---
name: rust-build
description: Verify Rust code compiles by running cargo build --all-targets
---

# Rust Build

Run:

```bash
cargo build --all-targets
```

- If it succeeds: report "build passed".
- If it fails: show the full compiler output, identify the root cause, and fix the issue before reporting complete.

Do not mark the task complete until the build passes.
