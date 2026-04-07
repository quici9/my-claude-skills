# Git Commit & PR

## Description

Generates Conventional Commits-compliant commit messages and professional PR descriptions. Ensures commits/PRs are easy to review, revert, and provide sufficient context for the team.

## Triggered When

- User says "tạo commit", "viết commit message", "gợi ý commit message"
- User says "create commit", "commit message", "suggest commit message"
- User says "viết mô tả PR", "tạo PR", "mô tả pull request này"
- User says "write PR description", "create PR", "describe PR"
- User shares a diff or change description and wants it packaged as a commit
- User asks "what should this commit say", "nên commit gì cho đoạn này"

## Conventional Commits Format

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Valid Types

| Type | When to Use |
|---|---|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Code change without behavior change |
| `test` | Add/update tests |
| `docs` | Documentation change |
| `style` | Formatting, lint (no logic change) |
| `perf` | Performance improvement |
| `chore` | Build, CI, config, dependencies |
| `ci` | CI/CD pipeline changes |
| `revert` | Revert a previous commit |

### Valid Scopes

- `core` — core logic changes
- `api`, `auth`, `db`, `config`
- Specific module/feature name
- `*` if changes span multiple scopes

### Rules

1. **Description**: imperative mood, concise (< 50 chars)
   - ✅ `add user login endpoint`
   - ❌ `added`, `adds`, `adding`
   - ❌ `Fix bug in login` (not imperative)

2. **Body**: explain WHY, not WHAT
   - WHAT = what the code does
   - WHY = why it was needed, business context

3. **Footer**: Breaking changes + issue refs
   - `BREAKING CHANGE: ...`
   - `Closes #123`, `Fixes #456`

## PR Description Template

```
## Summary
Brief description (1-2 sentences) of what this PR does and why.

## Type of Change
- [ ] Feature (feat)
- [ ] Bug fix (fix)
- [ ] Refactor
- [ ] Documentation
- [ ] Other

## Changes Made
1. ...
2. ...

## Test Plan
- [ ] Unit tests passed
- [ ] Manual testing: [describe]

## Screenshots / Logs
(include if UI or log changes)

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

## Workflow

1. **Read diff** — understand all changes
2. **Group changes** — which changes belong in 1 commit?
3. **Write message** — follow format above
4. **Preview** — read back to check clarity

## Output Format

```
## Commit Message

\`\`\`
<type>(<scope>): <description>

<body>
\`\`\`

## PR Description

[filled template]

## Alternative (if multiple commits needed)

Commit 1: ...
Commit 2: ...
```
