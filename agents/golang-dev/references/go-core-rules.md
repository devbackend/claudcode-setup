# Go Core Rules

- Return errors, never panic (except `main`)
- Use `context.Context` as the first parameter
- Use structured logging with `slog`
- Wrap errors: `fmt.Errorf("description: %w", err)`
- Use ENV variables for secrets and environment-specific config

All code must pass:
```
go build ./...
go test ./... -race
golangci-lint run --allow-parallel-runners ./... --fix
```
