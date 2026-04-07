# Secrets Detection

## Description

Detects leaked credentials, API keys, tokens, and secrets in source code, config files, logs, and git history. Prevents secrets from being committed to repositories via pre-commit hooks and CI/CD gates. Supports TruffleHog, Gitleaks, detect-secrets, and custom regex patterns.

## Triggered When

- User says "scan for secrets", "detect API keys", "check for leaked credentials"
- User says "quet secrets", "phat hien API key lo", "kiem tra credential"
- User asks "is there a leaked password in this repo", "scan git history"
- Setting up pre-commit hooks for secrets prevention
- CI/CD pipeline security setup
- User says "add secrets scanning", "TruffleHog setup", "Gitleaks config"
- After merging a PR with potential secrets (incident response)
- User asks "how to prevent credentials in code", "stop secrets from being committed"

## Secret Categories Detected

| Category | Examples |
|---|---|
| Cloud Provider Keys | AWS Access Key (AKIA...), AWS Secret, GCP, Azure |
| API Keys | Stripe, GitHub token, Slack, SendGrid, Twilio |
| Private Keys | SSH private keys, PGP/GPG keys, JWT secrets |
| Database | Connection strings with password, MongoDB URI |
| Auth Tokens | Bearer tokens, Basic auth credentials, OAuth tokens |
| Generic Secrets | password=, secret=, token=, api_key= in config |
| Asymmetric Keys | -----BEGIN RSA PRIVATE KEY-----, -----BEGIN EC PRIVATE KEY----- |

## Tool Comparison

| Tool | Strengths | Best For |
|---|---|---|
| TruffleHog v3 | Scans git history (commits), high accuracy | Finding leaked secrets in git history |
| Gitleaks | Fast, pre-commit friendly, GitHub Action native | Pre-commit hooks + CI/CD |
| detect-secrets | Baseline file, non-invasive, minimal false positives | Baseline approach |
| GitGuardian Shield | SaaS, team dashboard, high coverage | Teams with GUI/dashboard needs |
| Semgrep (secret scan rules) | Custom rules, IDE integration | Developers who already use Semgrep |

## Setup and Configuration

### 1. TruffleHog v3

```bash
# Install
brew install trufflesecurity/tap/trufflehog

# Scan local repo (including git history)
trufflehog filesystem . --no-update

# Scan git history (most common use)
trufflehog git https://github.com/org/repo.git \
  --no-update \
  --fail \
  --format json > trufflehog-results.json

# Scan specific commit range
trufflehog git file://$(pwd) \
  --only-verified \
  --fail \
  --commit-range abc123..def456

# CI/CD usage (GitHub Actions)
- name: Scan for secrets
  uses: trufflesecurity/trufflehog@main
  with:
    path: ./
    base_depth: 0
    head_depth: 5
    fail_on: warning
```

### 2. Gitleaks

```bash
# Install
brew install gitleaks

# Initialize gitleaks config (creates .gitleaks.toml)
gitleaks protect -v --source . --staged

# Scan entire repo (generate report)
gitleaks detect \
  --source . \
  --report-path gitleaks-report.json \
  --report-format json \
  --fail-on-severity=high

# Diff scan (only changed files — fast for pre-commit)
gitleaks protect \
  --source . \
  --staged \
  --no-color

# Config file (.gitleaks.toml)
[gitprotect]
  scanmode = "diff"  # Only scan staged changes for pre-commit

# Custom rules (extend defaults)
[[rules]]
  id = "custom-api-key"
  description = "Custom API Key Pattern"
  regex = '''(?i)(myapp_api_key|myapp_secret)=['"]?([a-zA-Z0-9_-]{20,})['"]?'''
  secretGroup = 2
```

### 3. Pre-commit Hook (Gitleaks)

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.2
    hooks:
      - id: gitleaks
        args: ["--fail-on-severity=high"]
```

```bash
# Install pre-commit globally (one time)
brew install pre-commit
pre-commit install --hook-type pre-commit
pre-commit install --hook-type commit-msg
```

### 4. detect-secrets

```bash
# Install
pip install detect-secrets

# Initialize baseline (first time)
detect-secrets scan . > .secrets.baseline

# Scan and update baseline (add new findings)
detect-secrets scan . >> .secrets.baseline

# Audit baseline (mark false positives as false_positive)
detect-secrets audit .secrets.baseline

# Hook: prevent commit if new secrets found
detect-secrets-hook .secrets.baseline
```

```yaml
# .pre-commit-config.yaml (detect-secrets)
repos:
  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.4.0
    hooks:
      - id: detect-secrets
        args: ['--baseline', '.secrets.baseline']
        exclude: '\.secrets\.baseline$'
```

## CI/CD Integration

### GitHub Actions (Full Pipeline)

```yaml
# .github/workflows/secrets-scan.yml
name: Secrets Detection

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  gitleaks:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Required for full history scan

      - name: Run Gitleaks
        uses: gitleaks/gitleaks-action@v2
        env:
          GITLEAKS_LICENSE: ${{ secrets.GITLEAKS_LICENSE }}
        with:
          args: --fail-on-severity=high,critical
          config-format: toml
          config-path: .gitleaks.toml

  trufflehog:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: TruffleHog Scan
        uses: trufflesecurity/trufflehog@main
        with:
          path: ./
          base_depth: 0
          head_depth: 100
          fail_on: warning
```

### GitLab CI

```yaml
# .gitlab-ci.yml
secrets-scan:
  stage: security
  image: alpine/amd64:latest
  before_script:
    - apk add --no-cache git curl
    - curl -sSfL https://github.com/gitleaks/gitleaks/releases/download/v8.18.2/gitleaks_8.18.2_linux_amd64.tar.gz | tar -xz
  script:
    - ./gitleaks detect --source . --fail-on-severity=high --report-path gitleaks-report.json
  artifacts:
    reports:
      json: gitleaks-report.json
    when: always
```

## Baseline Workflow

```bash
# 1. Initial baseline (existing repo with potential secrets)
gitleaks detect --source . --report-path legacy-findings.json

# 2. Review and suppress false positives
# Edit legacy-findings.json, add "suppression" entries to .gitleaks.toml

# 3. Create clean baseline
detect-secrets scan . > .secrets.baseline

# 4. Mark false positives
detect-secrets audit .secrets.baseline

# 5. Going forward: only pre-commit + CI/CD checks
```

## Response Workflow (Secret Found)

```
Step 1: IDENTIFY
  - Which file? Which secret? Which commit?
  - trufflehog git --json file://.

Step 2: ASSESS
  - Is the secret ACTIVE? (check if API key is still valid)
  - AWS key? -> Revoke immediately via AWS IAM Console
  - GitHub token? -> Revoke in GitHub Settings > Developer Settings

Step 3: REMEDIATE
  - Rotate the secret immediately
  - If committed: git filter-branch / BFG Repo-Cleaner to remove
  - Update .gitleaks.toml or .secrets.baseline

Step 4: PREVENT
  - Add pre-commit hook to prevent recurrence
  - Add secret scanning to CI/CD gate

Step 5: NOTIFY
  - If production credentials: notify security team + affected users
  - If GDPR-relevant data: notify within 72 hours
```

## BFG Repo-Cleaner (Remove Secret from Git History)

```bash
# Install BFG
brew install bfg

# Remove file containing secret (rewrites history)
bfg --replace-text passwords.txt repo.git

# Remove specific string from all commits
bfg --replace-text "SECRET_TOKEN=.*//REMOVED" repo.git

# After BFG: force push (DANGER: coordinate with team)
git reflog expire --expire=now --all && git gc --prune=now --aggressive
git push origin --force --all
```

## Custom Patterns

### High-Risk Patterns to Catch

```toml
# .gitleaks.toml (custom rules)
[[rules]]
  id = "aws-access-key"
  description = "AWS Access Key ID"
  regex = '''AKIA[0-9A-Z]{16}'''
  entropy = 3.5

[[rules]]
  id = "private-key-block"
  description = "Asymmetric Private Key"
  regex = '''-----BEGIN (RSA |EC |DSA |OPENSSH )?PRIVATE KEY-----'''

[[rules]]
  id = "generic-api-key"
  description = "Generic API Key in ENV"
  regex = '''(?i)(api[_-]?key|apikey|api_secret)\s*[=:]\s*['"]?[a-zA-Z0-9_-]{20,}['"]?'''

[[rules]]
  id = "connection-string-password"
  description = "DB Connection String with Password"
  regex = '''(?i)(mongodb|postgres|mysql|redis|mssql):\/\/[^:]+:[^@]+@'''

[[rules]]
  id = "github-pat"
  description = "GitHub Personal Access Token"
  regex = '''ghp_[a-zA-Z0-9]{36}|github_pat_[a-zA-Z0-9_]{22,}'''
```

## Checklist

- [ ] Pre-commit hook installed (gitleaks or detect-secrets)
- [ ] CI/CD gate configured with --fail-on-severity=high
- [ ] Baseline file created for existing repo
- [ ] False positives audited and suppressed in baseline
- [ ] Secrets manager configured (AWS Secrets Manager / HashiCorp Vault)
- [ ] Team educated on NEVER committing secrets to code
- [ ] Response workflow documented for incident response

## Output Format

```
## Secrets Detection — [Context]

### Tools Active
- Pre-commit: [gitleaks / detect-secrets / none]
- CI/CD:      [trufflehog / gitleaks-action / none]
- Baseline:   [created / exists / none]

### Findings (if scanned)
- Critical: [N] — [action required]
- High:     [N] — [action required]
- Medium:   [N] — [review required]
- Low:      [N] — [informational]

### Secrets Management
- Vault: [configured / not configured]
- AWS Secrets Manager: [configured / not configured]

### Overall: CLEAN / FINDINGS NEED REVIEW / CRITICAL FOUND
```

## Rules

- **NEVER commit a secret to any branch** — even a private branch
- **Pre-commit is the first line of defense** — CI/CD is the second
- **When a secret is found, assume it is compromised** — rotate immediately
- **False positives must be audited** — do not suppress silently
- **Secrets must live in .env files** that are in .gitignore — never in config files checked in
