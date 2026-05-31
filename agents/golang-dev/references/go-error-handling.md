# Go Error Handling

- Wrap with context: `fmt.Errorf("description: %w", err)`
- Log with structured fields via `slog`
- Never panic in production code — only `main` may panic
- Return domain errors from the usecase layer
