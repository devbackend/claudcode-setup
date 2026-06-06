---
name: review-security
description: Security-focused semantic review of changed code. Language-agnostic. Checks for injection vulnerabilities, secret leaks, unsafe patterns, and authentication issues.
---

# Review Security

## Load context

Read: `~/.claude/agents/code-reviewer/references/conventional-comments.md`

## Find changed files

```bash
git diff origin/<base_branch>...HEAD --name-only
```

## Review focus

Check all changed files for:

**Injection**
- SQL queries built with string concatenation instead of parameterised queries
- Shell commands built from user input (`exec.Command`, `os/exec`, `Command::new`)
- Path traversal: user input used in file paths without sanitisation

**Secrets & data exposure**
- Hardcoded credentials, API keys, tokens in source code
- Secrets logged or included in error messages
- Sensitive data in URLs or query parameters

**Unsafe patterns**
- `unsafe` blocks in Rust without documented invariants
- Unchecked type assertions/casts that could panic on untrusted input
- `#[allow(unsafe_code)]` without justification comment

**Authentication & authorisation**
- Missing authorisation checks on new endpoints
- JWT/token validation bypassed or weakened
- User-controlled input used to determine permissions

**Cryptography**
- Weak algorithms (MD5, SHA1 for security purposes, DES)
- Hardcoded IVs or salts
- Secrets stored in plaintext instead of hashed

## Output format

```
FINDING
file: <relative path>
line: <line number>
label: issue
decoration: blocking (security)
body: issue (blocking, security): <subject>\n\n<discussion>
---
```

If no findings: output `NO SECURITY FINDINGS`.
