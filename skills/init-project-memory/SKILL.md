---
name: init-project-memory
description: Initialize project-scoped memory directory (.claude/memory/) and ensure it is gitignored. Reusable across any agent that needs project memory.
---

# Initialize Project Memory

Check and initialize `.claude/memory/` in the current working directory:

1. Check if `.claude/memory/` exists.

2. If it does **not** exist:
   - Create the `.claude/memory/` directory
   - Create `.claude/memory/MEMORY.md` with content:
     ```
     # Memory
     ```
   - Add `.claude/memory/` to `.gitignore`:
     - If `.gitignore` exists: check if `.claude/memory/` is already listed; if not, append it on a new line
     - If `.gitignore` does not exist: create it containing `.claude/memory/`

3. If `.claude/memory/` already exists: do nothing, proceed silently.

Do not report anything to the user unless an error occurs.
