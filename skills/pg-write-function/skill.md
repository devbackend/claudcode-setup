---
name: pg-write-function
description: Write or update a PL/pgSQL function, trigger, stored procedure, view, or materialized view in a PostgreSQL project. Reads existing schema for context before writing.
---

# PG Write Function

## Before Writing

1. Read `.claude/memory/MEMORY.md` if it exists — check for schema directory location, naming conventions, or patterns specific to this project.

2. Search for the relevant schema files:
   - Look for existing files in the schema directory (common paths: `database/schema/`, `schema/`, `db/schema/`)
   - If modifying an existing function: read the current definition first
   - If creating a new function: read the file for the relevant domain (e.g. `schema/api/invoices.sql`) to understand naming patterns and existing helper functions

## Writing Rules

**Function structure:**
- Use `CREATE OR REPLACE FUNCTION` for functions and procedures
- Use `CREATE OR REPLACE VIEW` for views
- Always specify explicit `RETURNS` type — never rely on implicit returns
- Set `LANGUAGE plpgsql` (or `sql` for simple expressions)
- Set `SECURITY DEFINER` only when explicitly required, and add a `SET search_path = pg_catalog, public` guard in that case

**NULL handling:**
- Treat all nullable inputs as potentially NULL — use `COALESCE` or `IS NULL` checks
- Use `STRICT` qualifier only if the function must return NULL on any NULL input and that behavior is intentional

**Error handling:**
- Use `RAISE EXCEPTION` with a clear message and `SQLSTATE` when preconditions fail
- Prefer `RAISE EXCEPTION USING ERRCODE = 'P0001'` for application-level errors

**Performance:**
- Declare `STABLE` or `IMMUTABLE` when the function has no side effects — this enables index usage in query plans
- Avoid `SELECT *` inside function bodies — name columns explicitly
- Avoid nested loops over large sets — prefer set-returning functions with JOIN

**Dynamic SQL:**
- Never concatenate user input into dynamic SQL strings
- Always use `EXECUTE ... USING param1, param2` for parameterized dynamic SQL
- Validate and whitelist any identifiers (table/column names) before interpolating them

## After Writing

Report the full function definition and the file it was written to.
