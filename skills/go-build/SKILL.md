---
name: go-build
description: Verify Go code compiles by running go build ./...
---

# Go Build

Run:

```bash
go build ./...
```

- If it succeeds: report "build passed".
- If it fails: show the full compiler output, identify the root cause, and fix the issue before reporting complete.

Do not mark the task complete until the build passes.
