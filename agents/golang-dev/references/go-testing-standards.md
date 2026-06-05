# Go Testing Standards

## Assertions

- Use `github.com/stretchr/testify`
- `require.*` — fatal assertions (stops test on failure)
- `assert.*` — non-fatal assertions (test continues on failure)

## Context

Use `t.Context()` instead of `context.Background()` in all tests.

## Table-Driven Tests

Always use `map[string]struct{}` where the key is the test case name. See `~/.claude/examples/go-table-driven-test.go`.

## Integration Tests

- Always check `testing.Short()` and skip with `t.Skip("skipping integration test")` when `-short` flag is passed
- Use `testcontainers-go` for database tests to ensure isolation

## Coverage & Benchmarks

- Target ≥80% coverage for business logic (domain, usecase layers)
- Write benchmarks for performance-sensitive operations:
  ```
  go test -bench=. -benchmem -benchtime=3s
  ```
- Profile hot paths:
  ```
  go test -cpuprofile=cpu.prof -memprofile=mem.prof
  ```

## Mocks

- Generate mocks with `go generate ./...` after any `contracts.go` change
- Use generated mocks with `gomock.NewController(t)` in unit tests
