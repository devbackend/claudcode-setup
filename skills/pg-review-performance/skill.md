---
name: pg-review-performance
description: Performance-focused review of PostgreSQL SQL code. Checks for missing indexes, sequential scans, N+1 patterns inside functions, inefficient joins, and volatile function misuse.
---

# PG Review — Performance

Review the target SQL code for performance issues.

## Checklist

**Missing indexes**
- Filter conditions on columns with no apparent index (`WHERE col = $1` on a large table)
- Foreign key columns without an index (Postgres does not auto-create FK indexes)
- Columns used in `ORDER BY` or `GROUP BY` that may benefit from an index

**Sequential scans**
- Queries that will scan the full table when a selective index could be used
- `LIKE '%term'` patterns that prevent btree index usage (suggest `pg_trgm` GIN index)
- Functions applied to indexed columns in WHERE (`WHERE lower(email) = $1` defeats a plain index — suggest a functional index)

**N+1 inside functions**
- Loops (`FOR row IN SELECT ...`) that execute another query per iteration — suggest set-returning rewrite with JOIN
- Repeated lookups of the same value inside a loop without caching

**Inefficient joins**
- Cross joins without a filter that may produce large intermediate sets
- Joining on expressions that prevent index use
- Subqueries that can be rewritten as a JOIN for better planner optimization

**Volatile function misuse**
- Functions that are `VOLATILE` (default) but have no side effects — prevents inlining and index use; should be `STABLE` or `IMMUTABLE`
- `STABLE` or `IMMUTABLE` on a function that actually reads or modifies data — incorrect classification causes wrong query plans

**Unbounded result sets**
- Functions returning large sets without `LIMIT` where the caller likely only needs a subset
- Missing pagination in API-facing set-returning functions

## Output format

```
FINDING
file: <path or "inline">
line: <line number if known>
label: suggestion
decoration: blocking (performance)
body: <subject>\n\n<explanation and recommended fix>
---
```

If no findings: output `NO PERFORMANCE FINDINGS`.
