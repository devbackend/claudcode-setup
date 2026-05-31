---
name: go-lint
description: Run golangci-lint with auto-fix on the entire Go codebase.
---

# Go Lint

Run:

```bash
golangci-lint run --allow-parallel-runners ./... --fix
```

- If it passes: report "lint passed".
- If there are unfixable issues: show the output, fix the issues manually, then re-run until clean.

Do not mark the task complete until lint passes.
