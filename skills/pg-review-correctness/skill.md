---
name: pg-review-correctness
description: Correctness-focused review of PostgreSQL SQL code. Checks for NULL handling errors, transaction safety issues, race conditions, wrong data types, and logic bugs.
---

# PG Review — Correctness

Review the target SQL code for correctness issues.

## Checklist

**NULL handling**
- Comparisons using `= NULL` instead of `IS NULL` / `IS NOT DISTINCT FROM`
- Functions that return NULL silently when an argument is NULL but `STRICT` is not declared
- Aggregates over nullable columns without considering NULL propagation (e.g. `SUM` returns NULL if all values are NULL)
- `NOT IN (subquery)` when the subquery may return NULL — always returns no rows; use `NOT EXISTS` instead

**Transaction safety**
- Missing `BEGIN` / `COMMIT` in migrations that alter data alongside DDL
- DDL statements inside a function that cannot be rolled back if the function fails (`CREATE INDEX`, `VACUUM`, `CLUSTER` are non-transactional)
- Check and update patterns without row-level locking (`SELECT ... FOR UPDATE` missing where needed to prevent race conditions)

**Race conditions**
- TOCTOU: check-then-act patterns (`IF EXISTS ... THEN INSERT`) without serialization — use `INSERT ... ON CONFLICT` or advisory locks
- Counter increments without atomic update (`UPDATE SET count = count + 1` is safe; `SELECT` then `UPDATE` is not)
- Sequences used to enforce uniqueness but gaps treated as errors

**Data type issues**
- Using `TEXT` for values with a known domain (UUIDs, emails, amounts) where a proper type adds constraints
- Storing monetary amounts as `FLOAT` or `DOUBLE PRECISION` — use `NUMERIC` or integer cents
- Timestamp columns without timezone (`TIMESTAMP` vs `TIMESTAMPTZ`) in a multi-timezone system
- Integer overflow risk: `INT` for IDs on tables expected to exceed 2 billion rows — use `BIGINT`

**Logic bugs**
- Off-by-one in date range filters (`<` vs `<=`, `BETWEEN` inclusive on both ends)
- `COALESCE` with a default that masks a missing required value instead of raising an error
- Recursive CTEs without a termination condition or depth limit

## Output format

```
FINDING
file: <path or "inline">
line: <line number if known>
label: issue
decoration: blocking (correctness)
body: <subject>\n\n<explanation and recommended fix>
---
```

If no findings: output `NO CORRECTNESS FINDINGS`.
