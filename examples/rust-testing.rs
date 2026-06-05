// Async test
#[tokio::test]
async fn test_fetch() {
    let result = fetch_data().await;
    assert!(result.is_ok());
}

// Parameterised test with rstest
#[rstest]
#[case(0, 0)]
#[case(1, 1)]
#[case(5, 120)]
fn test_factorial(#[case] input: u64, #[case] expected: u64) {
    assert_eq!(factorial(input), expected);
}

// Property-based testing with proptest
proptest! {
    #[test]
    fn roundtrip(s in "\\PC*") {
        let encoded = encode(&s);
        assert_eq!(decode(&encoded), s);
    }
}

// Mocking with mockall
#[cfg_attr(test, mockall::automock)]
pub trait Database {
    async fn get_user(&self, id: Uuid) -> Result<User>;
}

// In test:
let mut mock = MockDatabase::new();
mock.expect_get_user().returning(|_| Ok(fake_user()));
