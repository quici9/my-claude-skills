# CI/CD Pipeline

## Description

Expert in designing GitHub Actions CI/CD pipelines. Covers build, test, security scanning, deployment, and rollback with production-grade patterns for Node.js, Python, and NestJS projects.

## Triggered When

- User says "setup CI/CD", "create pipeline", "automate deploy"
- User says "setup CI/CD", "tạo pipeline", "tự động deploy", "GitHub Actions"
- User asks "how do I add tests to GitHub Actions" or "automate deployment"
- User says "thêm test vào pipeline", "automate deploy", "deploy tự động"
- User shares a CI failure or pipeline error
- User says "CI lỗi", "pipeline fail", "GitHub Actions lỗi"
- User asks about multi-environment deploy (dev/staging/prod)

## Pipeline Checklist

### 1. Trigger Conditions
- On `push` to `main` → deploy to staging/prod
- On `push` to `feature/*` → run tests only
- On `pull_request` → test + lint + type check
- On `tag` matching `v*` → production release
- Set `workflow_dispatch` for manual triggers
- Use `paths-filter` to skip unchanged services (monorepo)

### 2. Stages (in order)

#### Lint & Type Check
```yaml
- name: Lint & Type Check
  run: npm run lint && npm run typecheck
```

#### Unit Tests
```yaml
- name: Unit Tests
  run: npm run test:cov
```
- Fail on coverage drop (set threshold)
- Cache `node_modules`, `.turbo`, `__pycache__`

#### Integration Tests
- Spin up Docker services (`docker compose -f compose.test.yml up -d`)
- Wait for DB readiness before running tests
- Tear down after (always / on-failure)

#### Security Scan
- SAST: `trufflehog`, `Semgrep`, `bandit`
- Dependency scan: `npm audit --audit-level=high`, `pip-audit`
- Container scan: `trivy image` (if Docker build in pipeline)
- Fail pipeline on CRITICAL findings only (HIGH for security-heavy repos)

#### Build & Push
- Build Docker image with semver tag (`ghcr.io/org/repo:sha-{short}`)
- Push to container registry (GHCR, ECR, Docker Hub)
- Use OIDC/Workload Identity for AWS auth (no long-lived credentials)

#### Deploy
- Staging: automatic on merge to `main`
- Production: require manual approval (`environment: { required: true }`)
- Use deployment tools: ArgoCD, Flux, AWS CodeDeploy, or script-based
- Record deployment URL / commit SHA in PR status

### 3. Secrets Management
- Store secrets in GitHub Secrets or external vault (AWS SSM, Vault)
- Reference via `${{ secrets.SECRET_NAME }}`
- Never log secrets (set `no_log` on sensitive step outputs)
- Rotate secrets proactively

### 4. Monorepo / Multi-service
- Use `paths-filter` action to detect changed services
- Matrix strategy to build/test changed services in parallel
- Deploy only changed services to avoid full redeploy

### 5. Observability
- Update GitHub deployment status (commit, env, URL)
- Send Slack/Discord notification on failure
- Report test coverage trends to PR

## Output Format

```
## 🔄 CI/CD Pipeline — [AppName]

### Trigger Summary
| Event | Action |
|---|---|
| PR opened | Lint + Type Check + Tests |
| Merge to main | Build + Scan + Deploy staging |
| Tag v* | Deploy production (with approval) |

### Stages
1. [ ] Lint & Type Check
2. [ ] Unit Tests (cov threshold: X%)
3. [ ] Integration Tests
4. [ ] Security Scan (SAST + Dependency)
5. [ ] Build & Push Docker Image
6. [ ] Deploy Staging
7. [ ] Deploy Production (manual approval)

### Secrets Required
- ...

### Estimated Runtime
- ~X min

### Rollback Strategy
- ...
```

## Rules

- Keep pipeline fast: cache aggressively, skip unnecessary steps
- Fail fast: run fastest checks first (lint → tests → build)
- Security is non-negotiable: fail on CRITICAL CVEs
- Use OIDC for cloud auth (no access keys in secrets)
