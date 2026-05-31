---
name: go-extract-interface
description: Extract a minimal interface for an external dependency into contracts.go and generate a mock using mockgen.
---

# Go Extract Interface

## Before Starting

Read: `~/.claude/agents/golang-dev/references/go-isp-patterns.md`

## Steps

1. **Identify the dependency** — find the concrete type currently used as a struct field or passed directly
2. **Determine used methods** — grep the package for all method calls on the dependency; include only those actually called
3. **Create or update `contracts.go`** in the same package:
   - Add `//go:generate mockgen -source $GOFILE -destination mock_test.go -package $GOPACKAGE` at the top (if not present)
   - Define a minimal interface with only the methods identified in step 2
4. **Update the struct** — replace the concrete type field with the interface type
5. **Update constructors** — accept the interface type, not the concrete type
6. **Generate the mock**:
   ```bash
   go generate ./...
   ```
7. **Verify** the package still compiles:
   ```bash
   go build ./...
   ```

Do not include methods that are not called anywhere in the package — keep interfaces minimal.
