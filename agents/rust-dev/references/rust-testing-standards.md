# Rust Testing Standards

## Structure

- Unit tests: `#[cfg(test)]` module within the same file
- Integration tests: `tests/` directory
- Doc tests: `///` examples on all public APIs

## Async tests

Use `#[tokio::test]` for async tests. See `~/.claude/examples/rust-testing.rs`.

## Parameterised tests

Use `rstest` for parameterised tests. See `~/.claude/examples/rust-testing.rs`.

## Property-based testing

Use `proptest` or `quickcheck` for algorithmic/parsing code. See `~/.claude/examples/rust-testing.rs`.

## Mocking

Use `mockall` with `#[automock]` for trait-based mocking. See `~/.claude/examples/rust-testing.rs`.

## Coverage targets

- Test edge cases: empty inputs, overflow boundaries, concurrent access, error paths
- Include doc tests for all public API items
