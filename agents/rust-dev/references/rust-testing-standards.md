# Rust Testing Standards

## Structure

- Unit tests: `#[cfg(test)]` module within the same file
- Integration tests: `tests/` directory
- Doc tests: `///` examples on all public APIs

## Async tests

Use `#[tokio::test]` for async tests:

```rust
#[tokio::test]
async fn test_fetch() {
    let result = fetch_data().await;
    assert!(result.is_ok());
}
```

## Parameterised tests

Use `rstest` for parameterised tests:

```rust
#[rstest]
#[case(0, 0)]
#[case(1, 1)]
#[case(5, 120)]
fn test_factorial(#[case] input: u64, #[case] expected: u64) {
    assert_eq!(factorial(input), expected);
}
```

## Property-based testing

Use `proptest` or `quickcheck` for algorithmic/parsing code:

```rust
proptest! {
    #[test]
    fn roundtrip(s in "\\PC*") {
        let encoded = encode(&s);
        assert_eq!(decode(&encoded), s);
    }
}
```

## Mocking

Use `mockall` with `#[automock]` for trait-based mocking:

```rust
#[cfg_attr(test, mockall::automock)]
pub trait Database {
    async fn get_user(&self, id: Uuid) -> Result<User>;
}

// In test:
let mut mock = MockDatabase::new();
mock.expect_get_user().returning(|_| Ok(fake_user()));
```

## Coverage targets

- Test edge cases: empty inputs, overflow boundaries, concurrent access, error paths
- Include doc tests for all public API items
