---
name: review-go
description: Semantic code review of Go files in the current diff. Checks for ISP violations, goroutine leaks, error handling issues, concurrency bugs, and architectural problems. Outputs structured findings for GitHub posting.
---

# Review Go

## Load context

Read in order:
1. `~/.claude/agents/golang-dev/references/go-core-rules.md`
2. `~/.claude/agents/golang-dev/references/go-isp-patterns.md`
3. `~/.claude/agents/golang-dev/references/go-concurrency-patterns.md`
4. `~/.claude/agents/golang-dev/references/go-error-handling.md`
5. `~/.claude/agents/code-reviewer/references/conventional-comments.md`

## Find changed Go files

```bash
git diff origin/<base_branch>...HEAD --name-only | grep '\.go$'
```

For each changed file: read the full file AND the diff hunk for that file.

## Review focus

For each changed `.go` file, check:

- **ISP**: concrete types used as struct fields instead of interfaces; missing `contracts.go`
- **Goroutine leaks**: goroutines without `ctx.Done()` / `WaitGroup`; missing lifecycle management
- **Error handling**: errors swallowed with `_`; missing `fmt.Errorf` wrapping; panics outside `main`
- **Context propagation**: functions that should accept `context.Context` but don't
- **Concurrency**: shared mutable state without synchronisation; mutex used in async code
- **Testing**: new code without tests; table-driven tests not using `map[string]struct{}`
- **Functional options**: configurable structs not using options pattern

## Output format

For each finding output a block:

```
FINDING
file: <relative path>
line: <line number>
label: <conventional comments label>
decoration: <blocking|non-blocking|if-minor>
body: <label> (<decoration>): <subject>\n\n<discussion>
---
```

If no findings: output `NO GO FINDINGS`.
