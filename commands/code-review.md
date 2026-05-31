Launch the code-review agent on the current repository.

Use the Agent tool to invoke the `code-review` agent:

```
Agent(subagent_type="code-review", prompt="Find the open PR for the current branch, check it out in an isolated worktree, run semantic review, and post Conventional Comments inline to GitHub.")
```
