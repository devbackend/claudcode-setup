Launch pre-commit code review on local staged and unstaged changes.

Use the Agent tool to invoke the `code-reviewer` agent:

```
Agent(subagent_type="code-reviewer", prompt="Review all local staged and unstaged changes. Detect languages, run review skills in parallel, build a findings checklist with inline code snippets, open it in Plannotator for triage, auto-fix approved findings, then verify the result.")
```
