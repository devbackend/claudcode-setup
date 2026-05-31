# Conventional Comments

Format: `<label> [decorations]: <subject>\n\n[discussion]`

## Labels

| Label | Use when |
|---|---|
| `praise` | Something done well — always include genuine feedback |
| `nitpick` | Trivial style preference, not worth blocking |
| `suggestion` | Proposing a better approach with reasoning |
| `issue` | Identified problem that needs fixing |
| `question` | Something unclear, seeking clarification |
| `thought` | Idea worth considering, not blocking |
| `note` | Important context, informational only |
| `chore` | Small mechanical task before merge |
| `todo` | Necessary change, should be done |

## Decorations

| Decoration | Meaning |
|---|---|
| `(blocking)` | Must be resolved before merge |
| `(non-blocking)` | Nice to have, doesn't block |
| `(if-minor)` | Fix only if the change is trivial |
| `(security)` | Security-related |
| `(performance)` | Performance-related |

## Examples

```
issue (blocking): Goroutine started without context — will leak on cancellation.

Pass `ctx` as parameter and select on `ctx.Done()` inside the loop.
```

```
suggestion (non-blocking): Functional options pattern fits better here.

Allows callers to set only what they need without a growing constructor signature.
```

```
nitpick (non-blocking): Variable name `d` doesn't convey intent.
```

```
praise: Clean separation of concerns — the interface is minimal and testable.
```
