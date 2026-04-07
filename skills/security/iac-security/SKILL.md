# IaC Security

## Description

Scans Infrastructure as Code (IaC) for security misconfigurations in Terraform, Kubernetes, Helm, AWS CloudFormation, Dockerfile, Ansible, and serverless configs. Supports Checkov, tfsec, Terrascan, Kubescape, and integrates security gates into CI/CD pipelines.

## Triggered When

- User says "scan Terraform", "IaC security", "check Kubernetes YAML"
- User says "quet Terraform", "kiem tra YAML", "bao mat infrastructure"
- User asks "is my Terraform secure", "Kubernetes misconfiguration", "cloud hardening"
- Setting up IaC scanning in CI/CD
- User says "add Checkov", "add tfsec", "Kubescape setup"
- Writing new Terraform or Kubernetes manifests
- User asks "CIS benchmark for Kubernetes", "CIS benchmark for Terraform"
- User asks "how to prevent insecure infrastructure", "shift-left for infra"

## Tool Comparison

| Tool | Target | Strengths | Best For |
|---|---|---|---|
| **Checkov** | Terraform, Docker, K8s, CloudFormation, Ansible, Serverless | 1000+ policies, CI/CD native | All-in-one IaC scanner |
| **tfsec** | Terraform only | Fast, AWS/Azure/GCP native rules | Terraform-specific projects |
| **Terrascan** | Terraform, K8s, Docker, AWS CloudFormation | Policy as code, OPA rules | Multi-cloud IaC |
| **Kubescape** | Kubernetes, Helm | CIS K8s benchmark, RBAC analysis | Kubernetes-first |
| **Snyk IaC** | Terraform, CloudFormation, Serverless | IDE plugin, fix suggestions | Developer experience |
| **Hadolint** | Dockerfile | Linter, security best practices | Container hardening |
| **Open Policy Agent (OPA)** | Rego policies | Custom policy engine | Advanced teams |
| **Spectral** | OpenAPI, JSON Schema | API spec validation | API-first workflows |

## Checkov (Primary Tool)

### Setup

```bash
# Install
brew install checkov

# Scan Terraform
checkov -d ./terraform --framework terraform

# Scan Kubernetes
checkov -d ./k8s --framework kubernetes

# Scan Dockerfiles
checkov -d . --framework dockerfile

# Scan all frameworks
checkov -d . --framework terraform, kubernetes, dockerfile

# Output formats
checkov -d . -o json --output-file results.json
checkov -d . -o sarif --output-file results.sarif
checkov -d . -o table  # Human-readable
```

### Configuration

```toml
# .checkov.yaml (or checkov.yml in repo root)
check:
  skipped_checks:
    - CKV_AWS_144  # Skip S3 bucket not blocked with public access
    - CKV_K8S_22   # Skip "Mayan: not use default namespace"

  soft_fail: false  # Hard fail on findings (use for CI/CD gates)

directory:
  - terraform
  - kubernetes

framework:
  - terraform
  - kubernetes
  - dockerfile
```

### CI/CD Integration

```yaml
# .github/workflows/iac-security.yml
name: IaC Security

on:
  push:
    branches: [main, develop]
    paths:
      - 'terraform/**'
      - 'k8s/**'
      - 'docker-compose.yml'
      - 'Dockerfile'
      - '.checkov.yaml'
  pull_request:
    paths:
      - 'terraform/**'
      - 'k8s/**'

jobs:
  checkov:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run Checkov
        uses: bridgecrewio/checkov-action@master
        with:
          directory: .
          framework: terraform,kubernetes,dockerfile
          output_format: sarif
          output_file_path: results.sarif
          skip_check: CKV_AWS_144, CKV_K8S_22

      - name: Upload to GitHub Security tab
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: results.sarif

      - name: Fail on critical findings
        run: |
          if grep -q '"severity": "CRITICAL"' results.sarif; then
            echo "Critical IaC issues found! Blocking deploy."
            exit 1
          fi
```

## tfsec

```bash
# Install
brew install tfsec

# Scan directory
tfsec ./terraform

# Scan with specific cloud
tfsec ./terraform --cloud aws

# Ignore specific checks
tfsec ./terraform --ignore-hcl-warnings --exclude CKV_AWS_144,CKV2_AWS_6

# CI/CD
tfsec ./terraform \
  --format sarif \
  --output-path tfsec-results.sarif \
  || exit 1
```

```yaml
# .github/workflows/tfsec.yml
- name: tfsec
  uses: aquasecurity/tfsec-action@v1
  with:
    soft_fail: false
    args: --exclude CKV_AWS_144,external-grants --format=sarif --out=tfsec-results.sarif
```

## Kubescape (Kubernetes Security)

```bash
# Install
brew install kubescape

# Scan cluster
kubescape scan cluster --context kind-demo

# Scan local manifest
kubescape scan -f deployment.yaml

# Scan git repo
kubescape scan https://github.com/kubescape/kubescape

# CIS Benchmark (Kubernetes)
kubescape scan control CIS-K8s-1.0 --include-namespaces default,production

# RBAC security analysis
kubescape scan framework rbac

# Output
kubescape scan -f deployment.yaml --format json --output results.json
kubescape scan -f deployment.yaml --format sarif --output results.sarif
```

```yaml
# .github/workflows/kubescape.yml
- name: Kubescape
  uses: kubescape/kubescape-action@v3
  with:
    files: |
      ./k8s/deployment.yaml
      ./k8s/service.yaml
      ./k8s/configmap.yaml
    framework: cis-k8s
    severity: high,critical
    failThreshold: high
    outputFormat: sarif
    outputFile: kubescape-results.sarif
```

### Kubescape Controls

```bash
# Run specific security controls
kubescape scan control \
  KSV001 \     # Container is running as root
  KSV002 \     # Container is privileged
  KSV003 \     # Container capabilities not dropped
  KSV012 \     # Container securityContext is not set
  KSV023 \     # Root filesystem is read-only
  KSV029      # Container does not drop ALL capabilities

# Full RBAC analysis
kubescape scan framework rbac
```

## Terrascan

```bash
# Install
brew install terrascan

# Scan Terraform
terrascan scan -t terraform -d ./terraform

# Scan Kubernetes
terrascan scan -t k8s -d ./k8s

# Scan with policy violation as error
terrascan scan -t terraform -d ./terraform -o console
terrascan scan -t terraform -d ./terraform -o yaml --output-file results.yaml

# Serverless scan (AWS Lambda)
terrascan scan -t serverless -d ./serverless
```

## Common Security Policies

### Terraform Hardening

| Check ID | Issue | Fix |
|---|---|---|
| CKV_AWS_1 | S3 bucket public | Block public access |
| CKV_AWS_5 | RDS not encrypted at rest | Enable encryption |
| CKV_AWS_43 | KMS key rotation disabled | Enable rotation |
| CKV_AWS_144 | S3 bucket public access not blocked | Add public access block |
| CKV_AWS_24 | Security group allows 0.0.0.0/0 on port 22 | Restrict to specific IPs |
| CKV_AWS_52 | MFA not enabled for S3 | Add MFA requirement |
| CKV_AWS_144 | S3 bucket without versioning | Enable versioning |
| CKV2_AWS_6 | Security group not attached to ENI | Attach to ENI |
| CKV_K8S_13 | CPU/Memory limits not set | Add resources limits |

### Terraform Example (Hardened)

```hcl
# S3 Bucket — Hardened
resource "aws_s3_bucket" "app_storage" {
  bucket = "myapp-storage-${var.environment}"

  tags = {
    Name        = "myapp-storage-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "app_storage" {
  bucket = aws_s3_bucket.app_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "app_storage" {
  bucket = aws_s3_bucket.app_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_storage" {
  bucket = aws_s3_bucket.app_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
```

```hcl
# RDS — Hardened
resource "aws_db_instance" "app_db" {
  identifier           = "myapp-db-${var.environment}"
  engine               = "postgres"
  engine_version       = "15.3"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  storage_encrypted    = true  # CKV_AWS_5
  deletion_protection  = var.environment == "prod" ? true : false
  skip_final_snapshot  = var.environment != "prod"

  backup_retention_period = var.environment == "prod" ? 7 : 1
  backup_window          = "03:00-04:00"
  maintenance_window    = "mon:04:00-mon:05:00"

  # Network
  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = aws_db_subnet_group.app.name

  # Monitoring
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  performance_insights_enabled    = true

  # Do NOT set publicly_accessible = true
}
```

### Kubernetes Hardening

```yaml
# deployment.yaml — Hardened
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
  namespace: production
  labels:
    app: app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: app
  template:
    metadata:
      labels:
        app: app
    spec:
      securityContext:           # Pod-level
        runAsNonRoot: true
        runAsUser: 1001
        runAsGroup: 1001
        fsGroup: 1001
        seccompProfile:
          type: RuntimeDefault

      containers:
        - name: app
          # Image: pin digest, use distroless
          image: gcr.io/distroless/nodejs@sha256:abc123
          ports:
            - containerPort: 3000

          securityContext:        # Container-level
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
            capabilities:
              drop: [ALL]
            privileged: false
            runAsNonRoot: true

          resources:
            limits:
              cpu: "500m"
              memory: "128Mi"
            requests:
              cpu: "100m"
              memory: "64Mi"

          volumeMounts:
            - name: tmp
              mountPath: /tmp

          # Liveness + Readiness probes
          livenessProbe:
            httpGet:
              path: /health
              port: 3000
            initialDelaySeconds: 5
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /ready
              port: 3000
            initialDelaySeconds: 3
            periodSeconds: 5

      volumes:
        - name: tmp
          emptyDir:
            medium: Memory
            sizeLimit: 64M

---
# NetworkPolicy — Zero-trust
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: app-netpol
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: app
  policyTypes:
    - Ingress
    - Egress
  ingress: []   # Deny all ingress by default
  egress: []    # Deny all egress by default
```

## OPA / Rego Custom Policies

```rego
# Allow only specific container registries
package kubernetes.admission

deny[msg] {
  input.request.kind.kind == "Pod"
  container := input.request.object.spec.containers[_]
  not startswith(container.image, "gcr.io/distroless/")
  not startswith(container.image, "registry.internal.company.com/")
  not startswith(container.image, "ghcr.io/")
  msg := sprintf("Container image '%v' is not from an approved registry", [container.image])
}

deny[msg] {
  input.request.kind.kind == "Pod"
  container := input.request.object.spec.containers[_]
  container.securityContext.privileged == true
  msg := "Privileged containers are not allowed"
}

deny[msg] {
  input.request.kind.kind == "Pod"
  container := input.request.object.spec.containers[_]
  not container.securityContext.runAsNonRoot
  msg := "Container must not run as root (runAsNonRoot: true)"
}

deny[msg] {
  input.request.kind.kind == "Pod"
  container := input.request.object.spec.containers[_]
  not container.securityContext.allowPrivilegeEscalation == false
  msg := "Container must not allow privilege escalation"
}
```

## Docker Compose Security (IaC context)

```yaml
# docker-compose.yml — Hardened
version: '3.9'

services:
  api:
    build: .
    user: "1001:1001"              # Non-root
    read_only: true                # Read-only filesystem
    tmpfs:
      - /tmp:rw,noexec,nosuid,size=64m
    cap_drop: [ALL]                # Drop all capabilities
    healthcheck:
      test: ["CMD", "wget", "-q", "--spider", "http://localhost:3000/health"]
      interval: 30s
      timeout: 3s
      retries: 3
    deploy:
      resources:
        limits:
          memory: 256M
          cpus: '0.5'
    networks:
      - backend
    # Never do this:
    # privileged: true
    # network_mode: host
    # cap_add: [ALL]
    # volumes:
    #   - /:/host  # Host filesystem access

networks:
  backend:
    driver: bridge
    driver_opts:
      com.docker.network.bridge.name: br-backend
      com.docker.network.bridge.enable_icc: "false"
```

## Checklist

- [ ] Checkov / tfsec configured in CI/CD
- [ ] Kubescape configured for Kubernetes
- [ ] Terrascan configured for multi-cloud
- [ ] Terraform: S3 buckets have public access blocked
- [ ] Terraform: RDS encrypted at rest, backups enabled
- [ ] Terraform: Security groups restrict to known CIDRs
- [ ] Terraform: KMS keys have rotation enabled
- [ ] Kubernetes: Pods run as non-root
- [ ] Kubernetes: Privileged containers blocked by OPA
- [ ] Kubernetes: NetworkPolicy set to default-deny
- [ ] Kubernetes: Container images from approved registries only
- [ ] Docker Compose: Non-root user, no privileged mode
- [ ] Dockerfile: Multi-stage build, no shell in final image
- [ ] Secrets scanned in IaC configs (Checkov secrets check)
- [ ] CI/CD gate: fail on CRITICAL/HIGH findings

## Output Format

```
## IaC Security — [Context]

### Framework: [Terraform / Kubernetes / Docker / Mixed]
### Tool: [checkov / tfsec / kubescape / terrascan]

### Terraform Findings
- Critical: [N] — [action]
- High:     [N] — [action]
- Medium:   [N] — [review]

### Kubernetes Findings
- Critical: [N] — [action]
- High:     [N] — [action]
- Medium:   [N] — [review]

### Docker Compose / Dockerfile
- Issues: [N]

### Policy Coverage
- Approved registries: [configured / not configured]
- NetworkPolicy default-deny: [configured / not configured]
- OPA policies: [N] active

### Overall: SECURE / REVIEW WARNINGS / ISSUES FOUND
```

## Rules

- **IaC security must be in CI/CD** — manual review is not enough
- **Deny by default** — network policies, container registries, IAM permissions
- **Never hardcode secrets in Terraform** — use AWS Secrets Manager / Vault provider
- **Tag all resources** — enables cost tracking, ownership, and security policies
- **Pin all image versions** — no :latest in any environment
- **Immutable infrastructure** — prefer recreate over modify
- **Compliance as code** — encode CIS/NIST/PCI-DSS benchmarks as Checkov policies
