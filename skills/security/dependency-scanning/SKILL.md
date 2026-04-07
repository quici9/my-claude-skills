# Dependency Scanning

## Description

Detects known vulnerabilities (CVEs) in project dependencies before they reach production. Covers npm/pip/cargo/nuget ecosystems, Docker base images, and CI/CD integration gates. Supports npm audit, Snyk, Trivy, Grype, Dependabot, and Renovate.

## Triggered When

- User says "scan dependencies", "check for vulnerabilities", "CVE scan"
- User says "quet thu vien", "kiem tra lo hong dependency", "audit package"
- User asks "are there vulnerable packages", "check npm audit", "dependency check"
- Setting up CI/CD security gates
- User says "add Snyk", "add Trivy", "Dependabot setup"
- Merging a PR that adds a new dependency
- User says "supply chain security", "SBOM", "vulnerable dependency found"
- User asks "how to prevent malicious packages", "typosquatting protection"

## Vulnerability Severity (CVSS)

| Severity | CVSS Score | Action |
|---|---|---|
| CRITICAL | 9.0 - 10.0 | Fix immediately, block deploy |
| HIGH | 7.0 - 8.9 | Fix within 7 days, strict gate |
| MEDIUM | 4.0 - 6.9 | Fix within 30 days, warn gate |
| LOW | 0.1 - 3.9 | Track, fix in next sprint |

## Tool Comparison

| Tool | Type | Strengths | Best For |
|---|---|---|---|
| npm audit / pip-audit / cargo audit | Built-in CLI | No install, fast | Quick local check |
| Snyk | SaaS + CLI | Huge DB, IDE plugin, fix PRs | Teams, automated remediation |
| Trivy | Open-source | Containers + code + IaC | All-in-one security scanner |
| Grype | Open-source | Fast, SBOM generation | Lightweight alternative to Trivy |
| Dependabot | GitHub-native | Auto PR for updates | Automatic vulnerability patches |
| Renovate | OSS bot | Auto update, flexible config | Advanced teams |
| Socket.dev | SaaS | Detects malicious packages, typosquatting | Supply chain attacks |

## Quick Scan Commands

```bash
# Node.js / npm
npm audit --audit-level=moderate
npm audit --audit-level=high
npm audit --audit-level=critical

# Python / pip
pip-audit
pip-audit --dry-run-run

# Rust / Cargo
cargo audit

# Go
go run golang.org/x/vuln/cmd/govulncheck@latest ./...

# .NET / NuGet
dotnet list package --vulnerable
dotnet restore && dotnet-gcd

# Ruby / Bundler
bundle audit

# Java / Maven
mvn org.whitesource:maven-whitesource-plugin:check
```

## Snyk

### Setup

```bash
# Install CLI
npm install -g snyk

# Authenticate
snyk auth

# Scan project
snyk test
snyk test --severity-threshold=high

# Scan Docker image
snyk container test node:18-alpine

# Generate SBOM
snyk sbom --format=spdx --output-file=sbom.spdx.json
```

### Configuration

```yaml
# .snyk or snyk.yaml
version: 2

patch:
  '*':
    - '+@snyk+protect*':
        patched: 'true'

# Ignore specific vulnerabilities (last resort)
ignore:
  '*':
    - id: 'SNYK-JS-LODASH-450202'
      reason: 'Internal use only, not exposed to network'
      expires: '2025-12-31T00:00:00.000Z'
```

### GitHub Actions

```yaml
# .github/workflows/snyk.yml
name: Snyk Security

on:
  push:
    branches: [main]
  pull_request:

jobs:
  snyk:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run Snyk
        uses: snyk/actions/node@master
        continue-on-error: true
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        with:
          args: --severity-threshold=high --fail-on=all

      - name: Upload report
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: snyk-report
          path: snyk.sarif

      - name: Post to GitHub Security tab
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: snyk.sarif
```

## Trivy

```bash
# Install
brew install trivy

# Scan filesystem (fast, all files)
trivy fs --severity HIGH,CRITICAL .

# Scan Dockerfile base image
trivy image --severity HIGH,CRITICAL node:18-alpine

# Scan git repo (dependencies)
trivy fs --scanners vuln,secret,config path/to/repo

# Scan Kubernetes cluster
trivy k8s --cluster-context my-cluster

# Generate SBOM
trivy fs --format spdx-json --output sbom.json .

# Scan SBOM for vulnerabilities
trivy sbom sbom.json
```

```yaml
# trivy.yaml (configuration)
format: "table"
severity: ["CRITICAL", "HIGH"]
exit-code: 1        # Non-zero exit for CI gate
ignore-unfixed: false
security-checks:
  - vuln
  - secret
  - config
```

### GitHub Actions (Trivy)

```yaml
# .github/workflows/trivy.yml
name: Trivy Dependency Scan

on:
  schedule:
    - cron: '0 6 * * 1'  # Weekly scan
  push:
    branches: [main]
    paths: ['package-lock.json', '**/package.json', '**/requirements.txt']

jobs:
  trivy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run Trivy
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
          format: 'sarif'
          output: 'trivy-results.sarif'
          severity: 'CRITICAL,HIGH'

      - name: Upload to GitHub Security
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: 'trivy-results.sarif'

      - name: Fail on critical
        if: always()
        run: |
          if grep -q '"severity": "CRITICAL"' trivy-results.sarif; then
            echo "Critical vulnerabilities found! Blocking deploy."
            exit 1
          fi
```

## Grype

```bash
# Install
brew install grype

# Scan directory (SBOM auto-generated)
grype . --severity Critical,High

# Scan container image
grype alpine:3.18

# Output formats
grype . -o json > grype-results.json
grype . -o cyclonedx > sbom.cdx.json
grype . -o spdx > sbom.spdx

# SBOM Generation + Scan pipeline
syft . -o cyclonedx-json=sbom.json
grype sbom:sbom.json --fail-on Critical
```

## SBOM (Software Bill of Materials)

```bash
# Syft — generate SBOM for any ecosystem
brew install syft

# Generate SBOM
syft . -o cyclonedx-json=sbom.cdx
syft . -o spdx-tag-value=sbom.spdx

# Scan SBOM for new vulnerabilities
grype sbom:sbom.cdx --fail-on High

# Sign SBOM (SLSA / provenance)
syft . -o cyclonedx-json=sbom.json
cosign sign --predicate sbom.json $IMAGE_REF
```

### SBOM in CI/CD

```yaml
# GitHub Actions — generate + attest SBOM
- name: Generate SBOM
  uses: anchore/sbom-action@v0
  with:
    image-name: myapp:${{ github.sha }}
    format: spdx-json
    output-file: sbom.spdx.json

- name: Scan SBOM
  run: |
    grype sbom:sbom.spdx.json \
      --fail-on Critical \
      --severity-cutoff High
```

## Dependabot

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: 'npm'
    directory: '/'
    schedule:
      interval: 'weekly'
      day: 'monday'
    open-pull-requests-limit: 10
    groups:
      production-dependencies:
        dependency-type: 'production'
        update-types: ['minor', 'patch', 'version-update:semver-major']
      development-dependencies:
        dependency-type: 'development'
    labels:
      - 'dependencies'
    registries:
      - npm-registry

  - package-ecosystem: 'docker'
    directory: '/'
    schedule:
      interval: 'weekly'

  - package-ecosystem: 'github-actions'
    directory: '/'
    schedule:
      interval: 'weekly'
```

### Dependabot Security Updates

```yaml
# .github/dependabot.yml (security-only, faster)
version: 2
security-updates:
  - package-ecosystem: 'npm'
    directory: '/'
    open-pull-requests-limit: 5
    groups:
      production-dependencies:
        dependency-type: 'production'
    labels:
      - 'security'
      - 'dependencies'
    commit-message:
      prefix: 'fix'
      include: 'scope'
```

## Malicious Package Detection

```bash
# Socket.dev (detect supply chain attacks)
npm install -g @socketdev/socket-sdk
socket --version

# Scan for malicious packages
socket npm --package lodash
socket npm --package express

# GitHub Action
- name: Check for malicious packages
  uses: SocketDev/socket-security-action@v1
  with:
    api-key: ${{ secrets.SOCKET_API_KEY }}
```

### Typosquatting Protection

```bash
# Before installing a new package, verify it exists
# Common typosquatting: requesets (vs requests), expresss (vs express)

# Check package download count (legitimate packages have thousands)
npm view express downloads
npm view requress downloads  # typosquatting

# Verify publisher / maintainer
npm view express | grep maintainer
```

## CI/CD Pipeline (Complete Example)

```yaml
# .github/workflows/dependency-security.yml
name: Dependency Security

on:
  push:
    branches: [main, develop]
  pull_request:
    paths:
      - 'package-lock.json'
      - 'package.json'
      - '**/requirements.txt'
      - '**/Gemfile.lock'
      - '**/go.sum'
      - 'Dockerfile'
      - 'docker-compose.yml'

jobs:
  audit:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        include:
          - ecosystem: npm
            command: npm audit --audit-level=high
          - ecosystem: pip
            command: pip-audit --fail-on=high
          - ecosystem: cargo
            command: cargo audit

    steps:
      - uses: actions/checkout@v4

      - name: Setup (${{ matrix.ecosystem }})
        uses: actions/setup-node@v4
        if: matrix.ecosystem == 'npm'
        with:
          node-version: '20'

      - name: Audit dependencies
        run: ${{ matrix.command }}

  trivy-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Trivy FS scan
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
          format: 'sarif'
          output: 'trivy-results.sarif'
          severity: 'CRITICAL,HIGH'

      - name: Upload to Security tab
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: 'trivy-results.sarif'

  sbom:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Generate SBOM
        uses: anchore/sbom-action@v0
        with:
          image-name: ${{ github.repository }}:${{ github.sha }}
          format: spdx-json
          output-file: sbom.spdx.json

      - name: Upload SBOM
        uses: actions/upload-artifact@v4
        with:
          name: sbom-spdx
          path: sbom.spdx.json
          retention-days: 30

  block-deploy:
    needs: [audit, trivy-scan]
    runs-on: ubuntu-latest
    if: failure()
    steps:
      - name: Block deploy
        run: |
          echo "Dependency vulnerabilities found! Deploy blocked."
          exit 1
```

## Checklist

- [ ] CI/CD gate configured (fail on Critical/High)
- [ ] SBOM generated and stored
- [ ] Dependabot / Renovate enabled for auto-updates
- [ ] Dependabot groups configured to reduce noise
- [ ] Security-only Dependabot PRs auto-labeled
- [ ] Malicious package detection (Socket.dev) considered
- [ ] License compliance check added (FOSSA or FOSSA-lite)
- [ ] Weekly scheduled vulnerability scan configured
- [ ] Vulnerability findings triaged and tracked in project board

## Output Format

```
## Dependency Scan — [Context]

### Ecosystem: [npm / pip / cargo / docker]
### Scan Tool: [trivy / snyk / grype / npm audit]

### Vulnerabilities Found
- Critical: [N] — [action]
- High:     [N] — [action]
- Medium:   [N] — [action]
- Low:      [N] — [informational]

### Patches Available
- Auto-fixable:  [N] — Dependabot PR ready
- Manual fix:    [N] — [package list]
- No fix yet:    [N] — [CVE list, monitor]

### SBOM
- Generated: [yes / no]
- Format:    [spdx / cyclonedx]
- Stored:    [location]

### Overall: CLEAN / WARNINGS / BLOCKED
```

## Rules

- **Critical vulnerabilities block deploy immediately** — no exceptions
- **Use SBOM** — know what is in your supply chain before scanning for CVEs
- **Pin dependency versions in production** — use lock files, do not use latest
- **Review every new dependency** — check publisher, downloads, last update, known issues
- **Automate updates** — Dependabot/Renovate must handle routine patches
- **Monitor for typosquatting** — verify package names before installing new deps
