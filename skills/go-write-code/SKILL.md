---
name: go-write-code
description: Implement a Go feature, fix a bug, or refactor existing Go code following project standards and ISP patterns.
---

# Go Write Code

## Before Writing

Read the following references:

1. `~/.claude/agents/golang-dev/references/go-core-rules.md`
2. `~/.claude/agents/golang-dev/references/go-error-handling.md`
3. `~/.claude/agents/golang-dev/references/go-functional-options.md`
4. `~/.claude/agents/golang-dev/references/go-concurrency-patterns.md`
5. `~/.claude/agents/golang-dev/references/go-isp-patterns.md`
6. If `.claude/memory/MEMORY.md` exists in the current project — read it for project-specific context (tech stack, conventions, patterns)

## Implementation

Apply the loaded standards:

- Use ISP: create `contracts.go` with minimal interfaces for every external dependency; never use concrete types as struct fields
- Run `go generate ./...` if `contracts.go` was created or modified
- Use functional options for configurable constructors
- Propagate `context.Context` as the first parameter
- Handle errors with `fmt.Errorf("description: %w", err)`
- Use `slog` for structured logging

## After Implementing

If you discovered a project-specific convention not already in `.claude/memory/` (e.g., which DB library, logger, patterns in use), save it as a memory file:

- Write the memory to `.claude/memory/<topic>.md` with frontmatter:
  ```
  ---
  name: <slug>
  description: <one-line summary>
  type: project
  ---
  ```
- Add a pointer to `.claude/memory/MEMORY.md`
