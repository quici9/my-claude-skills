# Container Security

## Description

Hardens Docker/OCI container images, scans for vulnerabilities in base images and dependencies, enforces runtime security policies, and integrates security scanning into CI/CD pipelines. Covers Dockerfile best practices, Trivy, Hadolint, Docker Bench, OPA Gatekeeper, and Falco.

## Triggered When

- User says "secure Docker image", "container security", "Dockerfile hardening"
- User says "bao mat container", "Dockerfile an toan", "kiem tra image"
- User asks "scan container image", "Trivy for Docker", "CVE in container"
- Setting up container scanning in CI/CD
- User says "Docker Bench", "OPA Gatekeeper", "runtime security"
- User asks "how to prevent privileged containers", "non-root user in Docker"
- Building a new Dockerfile
- User asks "which base image to use", "distroless vs alpine"

## Base Image Comparison

| Image | Size | Security | Use Case |
|---|---|---|---|
| alpine:latest | ~7MB | Good | Lightweight, but musl libc |
| debian:slim | ~80MB | Good | More packages available |
| distroless/static | ~2MB | Best | Static binaries, no shell |
| distroless/nodejs | ~50MB | Best | Node.js apps |
| scratch | 0MB | Best | Go/Rust static binaries |
| ubuntu:latest | ~77MB | Default | Not minimal, keep updated |
| node:18-alpine | ~180MB | Mixed | Node runtime, needs hardening |

**Recommendation**: Use gcr.io/distroless/nodejs or scratch (for compiled binaries) as the default choice.

## Dockerfile Hardening

### Hardened Dockerfile Template

```dockerfile
# Stage 1: Build (multi-stage)
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Stage 2: Production (minimal, no shell)
FROM gcr.io/distroless/nodejs20-debian11 AS production

# Set non-root user (CRITICAL)
RUN addgroup --system --gid 1001 appgroup && \
    adduser  --system --uid 1001 appuser --ingroup appgroup

WORKDIR /app

# Copy only what's needed (no package-lock, no dev deps)
COPY --from=builder --chown=appuser:appgroup /app/node_modules ./node_modules
COPY --chown=appuser:appgroup . .

# Drop privileges
USER appuser

# No shell, no package manager, no curl — attack surface = 0
ENTRYPOINT ["node", "dist/index.js"]
```

### Dockerfile Security Checklist

```dockerfile
# NEVER do this
FROM ubuntu:latest              # Too large, many packages
USER root                       # Running as root
RUN apt-get install curl wget   # Unnecessary packages
COPY . .                        # Copies everything including .git, .env
RUN pip install --no-cache-dir # Secrets in layers
EXPOSE 22                       # SSH exposed
CMD ["npm", "start"]            # No CMD validation

# DO this
FROM gcr.io/distroless/nodejs20-debian11  # Minimal, no shell
WORKDIR /app

# Pin base image version (never use :latest)
# Digest pin for production: gcr.io/distroless/nodejs@sha256:abc123...

# Multi-stage build (do not expose build tools in final image)
COPY --from=builder /app/dist ./dist

# Only root user if absolutely necessary
USER nonroot

# Health check
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', r => process.exit(r.statusCode === 200 ? 0 : 1))"

# Read-only filesystem
# docker run --read-only --tmpfs /tmp:rw,noexec,nosuid,size=64m myapp

# No secrets in image
# docker build --secret id=env=.env.production
```

### Secret Handling in Build

```dockerfile
# NEVER — secret in Dockerfile layer (persists in image history)
COPY .env.production .
RUN npm run build

# Use BuildKit secrets (not persisted in layer)
RUN --mount=type=secret,id=env \
    NPM_TOKEN=$(cat /run/secrets/env) npm ci

# Build-time secret via docker buildx
docker buildx build \
  --secret id=env=.env.production \
  --output type=image,name=myapp:prod .
```

### .dockerignore

```
.git
.gitignore
.env
.env.*
*.md
node_modules
npm-debug.log
Dockerfile
docker-compose.yml
.dockerignore
.github
tests/
coverage/
.vscode/
.idea/
**/*.test.js
**/*.spec.js
**/__tests__/
```

## Trivy (Container Image Scanning)

```bash
# Install
brew install trivy

# Scan Docker Hub image
trivy image node:18-alpine

# Scan local image
trivy image myregistry/myapp:1.0.0

# Scan filesystem (Docker context)
trivy fs --scanners vuln,secret,config .

# CI/CD gate format
trivy image \
  --severity CRITICAL,HIGH \
  --exit-code 1 \
  --ignore-unfixed \
  --no-progress \
  myapp:1.0.0

# Generate report
trivy image --format sarif --output trivy-results.sarif myapp:1.0.0
trivy image --format json  --output trivy-results.json  myapp:1.0.0
```

### GitHub Actions (Trivy in CI/CD)

```yaml
# .github/workflows/container-security.yml
name: Container Security

on:
  push:
    branches: [main]
    tags: ['v*']
  pull_request:
    paths: ['Dockerfile', 'docker-compose.yml', '**/package-lock.json']

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build image
        uses: docker/build-push-action@v5
        with:
          push: false
          tags: myapp:${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

      - name: Trivy scan (Vulnerability)
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: myapp:${{ github.sha }}
          format: 'sarif'
          output: 'trivy-results.sarif'
          severity: 'CRITICAL,HIGH'
          limit: 20
          exit-code: '1'  # Fail on CRITICAL/HIGH

      - name: Upload to GitHub Security tab
        uses: github/codeql-action/upload-sarif@v3
        if: always()
        with:
          sarif_file: 'trivy-results.sarif'

      - name: Trivy scan (Secrets)
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: myapp:${{ github.sha }}
          scan-type: 'secret'
          severity: 'CRITICAL,HIGH,MEDIUM'
```

## Hadolint (Dockerfile Linting)

```bash
# Install
brew install hadolint

# Lint Dockerfile
hadolint Dockerfile
hadolint --ignore DL3008 Dockerfile
hadolint --ignore DL3059 Dockerfile

# CI/CD
hadolint Dockerfile || exit 1
```

```yaml
# .github/workflows/hadolint.yml
- name: Lint Dockerfile
  uses: brpaz/hadolint-action@v1
  with:
    dockerfile: ./Dockerfile
    ignore: 'DL3008,DL3059'
```

### Common Hadolint Rules

| Rule | Issue | Fix |
|---|---|---|
| DL3005 | Do not use apt-get with --yes or --update | Split RUN commands |
| DL3006 | Tag must be specific (no :latest) | Use :1.0.0 or digest |
| DL3007 | Using :latest is risky | Pin tag explicitly |
| DL3008 | Use --no-install-recommends | apt-get install --no-install-recommends |
| DL3015 | Avoid curl to install packages | Use wget or official image |
| DL3025 | Use --chown in COPY | COPY --chown=user:group src dest |
| DL3045 | COPY before RUN npm install | Split for better cache |
| DL3047 | Avoid wget with -O | Use COPY instead |

## Docker Bench Security

```bash
# Run Docker Bench (host security configuration check)
docker run --rm -it \
  --network host \
  --pid host \
  --userns host \
  --cap-add audit_control \
  -v /var/lib:/var/lib \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /usr/lib/systemd:/usr/lib/systemd \
  -v /etc/docker:/etc/docker \
  --label docker_bench_security \
  aquasec/docker-bench-security

# Fail on WARNING in CI
docker run --rm -it \
  --network host \
  --pid host \
  -v $(pwd):/results \
  aquasec/docker-bench-security \
  -c check_5_2=1,check_5_3=1 \
  -l /results/docker-bench.log 2>&1 | tee docker-bench-output.txt

if grep -q "WARN" docker-bench-output.txt; then
  echo "Docker Bench found warnings!"
  exit 1
fi
```

## Runtime Security (Falco)

```yaml
# falco-config.yaml
rules:
  - rule: Terminal shell in container
    desc: A shell was spawned in a container other than at container start
    condition: >
      spawned_process and
      container and
      proc.name in (shell_binaries) and
      not container.entrypoint
    output: >
      Terminal shell in container (user=%user.name
      command=%proc.cmdline container=%container.name)
    priority: WARNING

  - rule: Privileged container started
    desc: Privileged container started
    condition: >
      containerprivileged and
      not trusted_images
    output: >
      Privileged container started
      (user=%user.name container=%container.name
      image=%container.image.repository)
    priority: CRITICAL

  - rule: Write to /etc directory
    desc: Writing to /etc
    condition: >
      write_to_etc_dir and
      not package_mgmt_binaries
    output: >
      Writing to /etc
      (user=%user.name container=%container.name
      file=%fd.name command=%proc.cmdline)
    priority: WARNING

  - rule: Sensitive file opened
    desc: A sensitive file was opened
    condition: >
      sensitive_file_read and
      not trusted_images
    output: >
      Sensitive file accessed
      (user=%user.name container=%container.name
      file=%fd.name command=%proc.cmdline)
    priority: INFO
```

```bash
# Install Falco via Helm on Kubernetes
helm install falco -n falco --create-namespace \
  falcosecurity/falco \
  -f falco-config.yaml
```

## OPA Gatekeeper (Kubernetes Admission Control)

```yaml
# Constraint template — require nonroot container
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: require nonroot container
spec:
  crd:
    spec:
      names:
        kind: K8sRequireNonRoot
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package kubernetes.admission
        deny[msg] {
          container := input.request.object.spec.containers[_]
          not container.securityContext.runAsNonRoot
          msg := "Container must set securityContext.runAsNonRoot: true"
        }

---
# Constraint
apiVersion: constraints.gatekeeper.sh/v1
kind: K8sRequireNonRoot
metadata:
  name: require-non-root
spec:
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
    excludedNamespaces: ["kube-system"]
```

### Kubernetes Pod Security Best Practices

```yaml
# securityContext best practices in Pod spec
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1001
    runAsGroup: 1001
    fsGroup: 1001
    seccompProfile:
      type: RuntimeDefault
    supplementalGroups: [1001]

  containers:
    - name: app
      securityContext:
        allowPrivilegeEscalation: false
        readOnlyRootFilesystem: true
        capabilities:
          drop: [ALL]
        privileged: false
      resources:
        limits:
          memory: "128Mi"
          cpu: "500m"
        requests:
          memory: "64Mi"
          cpu: "100m"
      volumeMounts:
        - name: tmp
          mountTmpfs: true
```

## Docker Compose Security

```yaml
# docker-compose.yml
version: '3.9'

services:
  app:
    build: .
    # Do NOT use: privileged: true
    # Do NOT use: network_mode: host (bypasses container isolation)
    # Do NOT use: cap_add: [ALL]
    user: "1001:1001"
    read_only: true
    tmpfs:
      - /tmp:rw,noexec,nosuid,size=64m
    healthcheck:
      test: ["CMD", "wget", "-q", "--spider", "http://localhost:3000/health"]
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 10s
    deploy:
      resources:
        limits:
          memory: 256M
          cpus: '0.5'
        reservations:
          memory: 128M
    secrets:
      - app_secret
    networks:
      - backend

secrets:
  app_secret:
    file: ./secrets/app_secret.txt

networks:
  backend:
    driver: bridge
```

## Registry Scanning

```bash
# Scan image in registry before pull
trivy image --severity CRITICAL,HIGH myregistry.io/myapp:v1.0.0

# Docker Scout (integrated in Docker Desktop)
docker scout cves myapp:1.0.0
docker scout recommendations myapp:1.0.0

# AWS ECR Enhanced Scanning
aws ecr describe-image-scan-findings \
  --repository-name myapp \
  --image-id imageTag=1.0.0 \
  --query 'imageScanFindings.findings[*]'
```

## Image Signing (Cosign)

```bash
# Install Cosign
brew install cosign

# Generate key pair
cosign generate-key-pair

# Sign image
cosign sign --yes myregistry.io/myapp:1.0.0

# Verify image (in deployment pipeline)
cosign verify myregistry.io/myapp:1.0.0
```

## Checklist

- [ ] Multi-stage Dockerfile (build tools not in final image)
- [ ] Non-root user in image
- [ ] Base image pinned (no :latest)
- [ ] .dockerignore configured
- [ ] Trivy scan in CI/CD (block on CRITICAL/HIGH)
- [ ] Hadolint linting in CI/CD
- [ ] Docker Bench Security run regularly
- [ ] Secrets injected at build time, not in image layers
- [ ] Read-only root filesystem enforced (--read-only or tmpfs)
- [ ] Kubernetes: Pod securityContext hardened
- [ ] OPA Gatekeeper policies active on K8s
- [ ] Falco runtime policies active on K8s/production
- [ ] Image signed (Cosign / Notary) and verified at deploy

## Output Format

```
## Container Security — [Image Name]

### Dockerfile Hardening
- Multi-stage: [OK / FAIL]
- Non-root user: [OK / FAIL]
- Base image pinned: [OK / FAIL]
- No latest tag: [OK / FAIL]
- Read-only FS: [OK / FAIL]
- Secrets in layers: [Clean / Found]

### Vulnerability Scan (Trivy)
- Critical: [N]
- High:     [N]
- Medium:   [N]

### Dockerfile Lint (Hadolint)
- Errors:   [N]
- Warnings: [N]

### Runtime Security
- Falco: [configured / not configured]
- OPA Gatekeeper: [configured / not configured]

### Image Signing
- Cosign / Notary: [signed / unsigned]

### Overall: SECURE / REVIEW WARNINGS / ISSUES FOUND
```

## Rules

- **Never run containers as root** — non-negotiable in production
- **Never use :latest tag** — pins must be exact, always
- **Multi-stage build is mandatory** — final image should have no shell, no package manager
- **No secrets in Dockerfile** — use BuildKit secrets or runtime injection
- **CI/CD gate is the last line of defense** — block on Critical/High CVEs
- **Runtime security (Falco) is not optional** — detect anomalies, do not just prevent at build time
