---
name: go-test
description: Run Go tests with race detection via go test ./... -race
---

# Go Test

Run:

```bash
go test ./... -race
```

- If all tests pass: report "tests passed".
- If any test fails: show the failure output, identify the root cause, and fix the issue before reporting complete.

Do not mark the task complete until all tests pass.
