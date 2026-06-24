---
name: pg-review
description: Run a full review of PostgreSQL SQL code — security, performance, and correctness — by invoking all three sub-skills in parallel. Use when you want a comprehensive review of a migration, function, or schema change.
---

# PG Review

Run all three review skills **in parallel**:

```
Agent: Skill("pg-review-security")
Agent: Skill("pg-review-performance")
Agent: Skill("pg-review-correctness")
```

Wait for all three to complete, then consolidate findings into a single report grouped by category.

## Output format

```
## Security
<findings from pg-review-security, or "No findings">

## Performance
<findings from pg-review-performance, or "No findings">

## Correctness
<findings from pg-review-correctness, or "No findings">
```

If all three return no findings, output: `ALL CHECKS PASSED — no issues found.`
