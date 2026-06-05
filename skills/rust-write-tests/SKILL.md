---
name: rust-write-tests
description: Write or update Rust tests for existing code, following project testing standards.
---

# Rust Write Tests

## Before Writing

Read the following references:

1. `~/.claude/agents/rust-dev/references/rust-testing-standards.md`
2. `~/.claude/agents/rust-dev/references/rust-error-handling.md`
3. If `.claude/memory/MEMORY.md` exists in the current project — read it for project-specific context

## Writing Tests

Apply the loaded standards:

- Unit tests go in `#[cfg(test)]` module in the same file
- Integration tests go in `tests/`
- Use `#[tokio::test]` for async tests
- Use `rstest` for parameterised test cases
- Use `proptest` for algorithmic / parsing code
- Mock trait dependencies with `mockall` — add `#[cfg_attr(test, mockall::automock)]` to the trait if missing
- Test edge cases: empty inputs, overflow boundaries, error paths, concurrent access
- Add doc tests (`///` examples) for all public API items

## Doc test example

See `~/.claude/examples/rust-doc-test.rs`.
