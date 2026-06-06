---
name: review-performance
description: Performance-focused semantic review of changed code. Checks for unnecessary allocations, N+1 queries, blocking hot paths, and missed optimisation opportunities.
---

# Review Performance

## Load context

Read: `~/.claude/agents/code-reviewer/references/conventional-comments.md`

## Find changed files

```bash
git diff origin/<base_branch>...HEAD --name-only
```

## Review focus

**Allocations (Go)**
- Slices grown in a loop without pre-allocated capacity (`make([]T, 0, n)`)
- Unnecessary `string` ↔ `[]byte` conversions in hot paths
- Interfaces boxing small values causing heap escapes
- `fmt.Sprintf` used for simple string concatenation

**Allocations (Rust)**
- Unnecessary `.clone()` where a borrow suffices
- `String` parameters where `&str` would work
- `Box<T>` for small, fixed-size types

**Database**
- N+1 query patterns: queries inside loops over result sets
- Missing indexes implied by new filter/sort fields
- Unbounded queries without `LIMIT`

**Concurrency**
- Blocking I/O called inside a goroutine/async task without timeout
- `sync.Mutex` held across I/O operations
- Channel operations that could deadlock under load

**Hot paths**
- Expensive operations (regex compilation, JSON unmarshalling) repeated instead of cached
- Logging at DEBUG/INFO level inside tight loops
- Unnecessary work done before an early-return guard

## Output format

```
FINDING
file: <relative path>
line: <line number>
label: <issue|suggestion|thought>
decoration: <blocking|non-blocking> (performance)
body: <label> (<decoration>, performance): <subject>\n\n<discussion>
---
```

If no findings: output `NO PERFORMANCE FINDINGS`.
