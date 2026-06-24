---
name: pg-write-migration
description: Create a new PostgreSQL migration file. Detects or recalls the project's migration convention (naming, directory, tool), then writes a correctly named .sql file with the requested DDL changes.
---

# PG Write Migration

## Step 1: Determine migration convention

### Check project memory first

Read `.claude/memory/MEMORY.md` in the current project. Look for a `pg-migrations` or similar entry that describes:
- Migration directory path
- File naming pattern (e.g. `{timestamp}_{name}.up.sql`, `V{version}__{name}.sql`, `{seq}_{name}.sql`)
- Migration tool in use (goose, migrate, flyway, liquibase, raw SQL)

If found, proceed directly to Step 2 using the stored convention.

### If not in memory, ask the user

Present two options:

> I don't have this project's migration convention recorded yet. How should I proceed?
> 1. **Read existing migrations** — I'll scan the existing migration directory to detect the naming pattern and tool
> 2. **Create a new migrations directory** — Tell me the desired path and naming convention

**Option 1 — Read existing migrations:**

Ask for (or search for) the migrations directory, then inspect up to 5 existing filenames to detect the pattern:
- Timestamp prefix (14-digit, 8-digit, epoch)?
- Sequential number (zero-padded)?
- Up/down suffix (`.up.sql` / `.down.sql`)?
- Single file per migration?
- Tool marker (goose annotations, flyway `V__`, etc.)?

**Option 2 — New directory:**

Ask:
- Directory path (e.g. `database/migrations`)
- Naming convention (show common options: timestamp, sequential, flyway-style)

After determining the convention, save it to project memory:
- Write `.claude/memory/pg-migrations.md` with the detected/chosen convention
- Add a pointer line to `.claude/memory/MEMORY.md`

## Step 2: Generate the migration file

Compute the next migration filename using the detected convention:
- For timestamp-based: use the current date-time in the correct format
- For sequential: find the highest existing number and increment

Write the migration file with:
- A descriptive name matching what the user requested
- The DDL changes inside (CREATE TABLE, ALTER TABLE, CREATE FUNCTION, etc.)
- `BEGIN; ... COMMIT;` wrapping if the project uses transactional migrations
- Goose annotations if the project uses goose (`-- +goose Up` / `-- +goose Down`)

## Step 3: Report

Output:
- The full path of the created file
- The migration content for review
