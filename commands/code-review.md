Launch the code-review agent on the current repository.

Use the Agent tool to invoke the `code-review` agent:

```
Agent(subagent_type="code-reviewer", prompt="Find the open PR for the current branch, check it out in an isolated worktree, run semantic review, and post Conventional Comments inline to GitHub. MANDATORY: all findings MUST be posted to GitHub as inline PR comments via gh api. Do not stop without posting comments.")
```
