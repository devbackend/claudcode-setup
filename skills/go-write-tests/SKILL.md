---
name: go-write-tests
description: Write or update Go tests for existing code, following project testing standards.
---

# Go Write Tests

## Before Writing

Read the following references:

1. `~/.claude/agents/golang-dev/references/go-core-rules.md`
2. `~/.claude/agents/golang-dev/references/go-testing-standards.md`
3. `~/.claude/agents/golang-dev/references/go-isp-patterns.md`
4. If `.claude/memory/MEMORY.md` exists in the current project — read it for project-specific context

## Writing Tests

Apply the loaded standards:

- Use `require.*` for fatal assertions, `assert.*` for non-fatal
- Use `t.Context()` instead of `context.Background()`
- Table-driven tests must use `map[string]struct{}` where the key is the test case name
- Integration tests must call `t.Skip(...)` when `testing.Short()` is true
- Use `testcontainers-go` for database isolation in integration tests
- Mock external dependencies with generated mocks (`gomock.NewController(t)`)
- If `contracts.go` exists but mocks are missing or stale, run `go generate ./...` first

## Coverage

Aim for ≥80% on business logic (domain and usecase layers).

Write benchmarks for any performance-sensitive code path:

```bash
go test -bench=. -benchmem -benchtime=3s
```
