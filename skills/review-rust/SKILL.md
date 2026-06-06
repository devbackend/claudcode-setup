---
name: review-rust
description: Semantic code review of Rust files in the current diff. Checks for unsafe usage, error handling issues, unnecessary allocations, ownership anti-patterns, and missing trait abstractions. Outputs structured findings for GitHub posting.
---

# Review Rust

## Load context

Read in order:
1. `~/.claude/agents/rust-dev/references/rust-core-rules.md`
2. `~/.claude/agents/rust-dev/references/rust-error-handling.md`
3. `~/.claude/agents/rust-dev/references/rust-concurrency-patterns.md`
4. `~/.claude/agents/rust-dev/references/rust-performance-patterns.md`
5. `~/.claude/agents/code-reviewer/references/conventional-comments.md`

## Find changed Rust files

```bash
git diff origin/<base_branch>...HEAD --name-only | grep '\.rs$'
```

For each changed file: read the full file AND the diff hunk for that file.

## Review focus

For each changed `.rs` file, check:

- **Unsafe**: `unsafe` blocks without invariant documentation; unjustified `transmute`
- **Error handling**: `.unwrap()` / `.expect()` in library code; swallowed errors; missing `.context()`
- **Ownership**: unnecessary `.clone()` where a borrow suffices; `String` params where `&str` works
- **Trait abstraction**: concrete types hardcoded where a trait + `#[automock]` would enable testing
- **Concurrency**: `std::sync::Mutex` used in async code; missing `Send + Sync` bounds; potential deadlocks
- **Performance**: allocations in hot paths; missing `with_capacity`; `dyn Trait` where generics suffice
- **Testing**: new public code without doc tests; missing unit tests for non-trivial logic

## Output format

```
FINDING
file: <relative path>
line: <line number>
label: <conventional comments label>
decoration: <blocking|non-blocking|if-minor>
body: <label> (<decoration>): <subject>\n\n<discussion>
---
```

If no findings: output `NO RUST FINDINGS`.
