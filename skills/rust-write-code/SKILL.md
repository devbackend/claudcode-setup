---
name: rust-write-code
description: Implement a Rust feature, fix a bug, or refactor existing Rust code following project standards and idiomatic patterns.
---

# Rust Write Code

## Before Writing

Read the following references:

1. `~/.claude/agents/rust-dev/references/rust-core-rules.md`
2. `~/.claude/agents/rust-dev/references/rust-error-handling.md`
3. `~/.claude/agents/rust-dev/references/rust-concurrency-patterns.md`
4. `~/.claude/agents/rust-dev/references/rust-performance-patterns.md`
5. `~/.claude/agents/rust-dev/references/rust-crate-preferences.md`
6. If `.claude/memory/MEMORY.md` exists in the current project — read it for project-specific context

## Implementation

Apply the loaded standards:

- Design types first: define structs, enums, and traits that model the domain correctly
- Use traits for dependency injection — never hardcode concrete types where a trait suffices
- Use `#[cfg_attr(test, mockall::automock)]` on traits that need to be mocked in tests
- Handle errors with `thiserror` (library) or `anyhow` (application) — never `.unwrap()` in library code
- Use `?` for propagation; add `.context()` to bare errors
- Prefer iterators over manual loops; use `rayon` for CPU-bound parallelism
- Keep `unsafe` minimal and document every invariant

## After Implementing

If you discovered a project-specific convention not already in `.claude/memory/` (e.g., async runtime config, custom error types, crate choices), save it as a memory file:

- Write to `.claude/memory/<topic>.md` using the format in `~/.claude/examples/memory-frontmatter.md`
- Add a pointer to `.claude/memory/MEMORY.md`
