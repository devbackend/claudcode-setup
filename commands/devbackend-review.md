Run a pre-commit code review on local staged and unstaged changes, present findings in Plannotator, auto-fix approved issues, then verify.

## Step 1 — Collect findings

Use the Agent tool to launch the `code-reviewer` subagent:

```
Agent(subagent_type="code-reviewer", prompt="Review all local staged and unstaged changes and return all FINDING blocks.")
```

If the result is `NO CHANGES` or `NO FINDINGS` — tell the user and stop.

## Step 2 — Build the checklist

For each FINDING block, read the relevant lines from the source file to extract a code snippet (3-7 lines centred on the finding line).

Build a markdown checklist:

```markdown
# Code Review

> N findings. Check items to fix, uncheck to skip.

## <Category>

- [ ] **<subject>** — `<file>:<line>`
  ```<lang>
  <code snippet>
  ```
  <explanation and recommended fix>
```

Group findings by category (Security, Performance, Go, SQL, Rust, etc.).

## Step 3 — Write to a temp file

```bash
_tmp=$(mktemp /tmp/devbackend-review-XXXXXX)
REVIEW_FILE="${_tmp}.md"
mv "$_tmp" "$REVIEW_FILE"
```

Write the markdown checklist to `$REVIEW_FILE`.

## Step 4 — Open in Plannotator

Run via Bash:

```bash
plannotator annotate "$REVIEW_FILE" --json
```

Parse the response:
- `"decision": "approved"` or `"decision": "dismissed"` → acknowledge and stop
- `"decision": "annotated"` → proceed to Step 5

## Step 5 — Auto-fix approved findings

From the feedback, identify which findings the user approved for fixing.

For each approved finding, launch the appropriate agent via Agent tool:
- Go findings → `Agent(subagent_type="golang-dev", prompt="Fix: <finding subject and context>")`
- SQL findings → `Agent(subagent_type="postgres-dev", prompt="Fix: <finding subject and context>")`
- Other findings → fix inline using Edit/Write tools

## Step 6 — Verify

Re-launch the `code-reviewer` subagent to verify no issues remain:

```
Agent(subagent_type="code-reviewer", prompt="Review all local staged and unstaged changes and return all FINDING blocks.")
```

Report the result:
- `NO FINDINGS` → "✅ All fixed findings verified — no remaining issues."
- Findings remain → list what still needs attention.
