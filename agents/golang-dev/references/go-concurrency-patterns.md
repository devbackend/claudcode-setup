# Go Concurrency Patterns

- Manage goroutine lifecycle with `context.Context` + `sync.WaitGroup`
- Use worker pools for bounded concurrency: `for i := 0; i < workers; i++ { go worker(ctx, jobs, results) }`
- Use pipeline patterns for multi-stage data processing
- Prefer channels for communication over shared memory with mutexes
- Ensure all goroutines can exit cleanly — no goroutine leaks
