# Go Core Rules

- Return errors, never panic (except `main`)
- Use `context.Context` as the first parameter
- Use structured logging with `slog`
- Wrap errors: `fmt.Errorf("description: %w", err)`
- Use ENV variables for secrets and environment-specific config

## Integer Types

Use explicit-width integer types everywhere: `int32`, `int64`, `uint32`, `uint64`.

- Default to `int64` / `uint64` when no external contract constrains the size
- Choose `int32` / `uint32` only when explicitly required (e.g., protobuf field typed as `int32`)
- Never use `int` or `uint` for struct fields, function parameters, or return values

**Allowed exceptions** (where `int` is correct):
- Loop indices over slices/arrays (`for i := 0; i < len(s); i++`)
- Values derived directly from `len()` / `cap()`
- Stdlib or external interface boundaries that mandate `int`

Enforce via `revive: use-fixed-width-int` in `.golangci.yml`. When working on a project that lacks this rule, add it.

All code must pass:
```
go build ./...
go test ./... -race
golangci-lint run --allow-parallel-runners ./... --fix
```
