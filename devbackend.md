# Global Claude Code Instructions

## Code Comments

Never write comments that describe what the code does. Only add a comment when the WHY is non-obvious: a hidden constraint, a subtle invariant, a workaround for a specific bug, or behavior that would surprise a reader.

## External Dependencies & Libraries

When looking up documentation for libraries, packages, or external dependencies — first check Context7 via MCP:

1. `mcp__context7__resolve-library-id` — find the library ID by name
2. `mcp__context7__get-library-docs` — fetch the documentation using that ID

If Context7 doesn't have the library, fall back to web search.
