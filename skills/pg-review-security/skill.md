---
name: pg-review-security
description: Security-focused review of PostgreSQL SQL code. Checks for SQL injection in dynamic SQL, unsafe SECURITY DEFINER usage, excessive privileges, and information leakage.
---

# PG Review — Security

Review the target SQL code for security issues.

## Checklist

**SQL Injection in dynamic SQL**
- Dynamic SQL built with string concatenation (`||`) instead of `EXECUTE ... USING`
- User-controlled values interpolated into `EXECUTE` without parameterization
- Table or column names sourced from user input without whitelist validation

**SECURITY DEFINER misuse**
- Function declared `SECURITY DEFINER` without `SET search_path = pg_catalog, public` — exposes it to search_path hijacking
- `SECURITY DEFINER` used without a documented reason for the privilege escalation

**Excessive privileges**
- `GRANT ALL` instead of minimal required privileges
- Functions or roles granted `SUPERUSER` unnecessarily
- `pg_read_file`, `pg_ls_dir`, `pg_read_binary_file` accessible to unprivileged roles

**Information leakage**
- Error messages that expose internal schema structure, row data, or system paths to callers
- `RAISE NOTICE` or `RAISE LOG` that logs sensitive column values (passwords, tokens, PII)

**Unsafe functions**
- `lo_import` / `lo_export` accessible without privilege check
- `COPY TO/FROM` with user-controlled file paths

## Output format

```
FINDING
file: <path or "inline">
line: <line number if known>
label: issue
decoration: blocking (security)
body: <subject>\n\n<explanation and recommended fix>
---
```

If no findings: output `NO SECURITY FINDINGS`.
