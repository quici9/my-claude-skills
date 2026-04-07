# DevSecOps & Secret Management

## Description

Expert in DevSecOps practices, container security, secret management, and TLS/HTTPS setup. Covers Vault, AWS Secrets Manager, K8s secrets, environment variable security, and container hardening.

## Triggered When

- User says "secure secrets", "setup secret management", "harden containers"
- User says "quản lý secret", "bảo mật API key", "docker security"
- User asks about TLS/HTTPS, certificate management, or SSL setup
- User says "HTTPS", "SSL certificate", "TLS setup", "chứng chỉ SSL"
- User shares a security incident, exposed secret, or breach concern
- User says "bị lộ key", "secret trong code", "lộ thông tin nhạy cảm"
- User asks about container security scanning, runtime protection, or IAM least privilege
- User asks "how do I rotate secrets" or "how to manage API keys securely"

## Secret Management Checklist

### 1. Secret Discovery & Prevention
- Scan codebases with `trufflehog filesystem .`, `gittyleaks`, or Gitleaks
- Add pre-commit hook to prevent committing secrets
- `.gitignore` must cover: `.env`, `.env.*`, `*.pem`, `*.key`, `credentials.json`
- Never `git add .env` or commit example `.env.example` with real values
- Use `git-secrets` or detect-secrets in CI

### 2. Secret Management Solutions (choose one)

| Solution | Best For | Notes |
|---|---|---|
| **Vault (HashiCorp)** | Multi-cloud, enterprise | Dynamic secrets, lease rotation |
| **AWS Secrets Manager / SSM** | AWS-only workloads | Integrated with IAM, Lambda |
| **GCP Secret Manager** | GCP workloads | Good for GKE, Cloud Run |
| **Doppler / 1Password** | Developer-friendly | CLI, .env sync, audit log |
| **K8s Secrets + Sealed Secrets** | Kubernetes | Encrypt secrets at rest |

### 3. Secret Injection Pattern
- **At runtime** via environment variables (app reads `$DB_PASSWORD`)
- **At startup** via entrypoint script (fetch from Vault → write to env file → exec app)
- **Sidecar** injection for Kubernetes (Vault Agent Sidecar)
- **Never** bake secrets into Docker image layers
- **Never** log secrets (sanitize in logging middleware)

### 4. Rotation Strategy
- Credentials rotatable without downtime (use aliases/pointers)
- Auto-rotation for DB passwords (30–90 day cycle)
- Certificate rotation before expiry (automate with cert-manager)
- Document rotation runbook for each secret type
- Test rotation procedure in staging first

## Container Security Checklist

### 1. Image Hardening
- Use minimal base image (`alpine`, `distroless`, `scratch` for Go binaries)
- Run as non-root user
- Set filesystem read-only (`--read-only`)
- Remove setuid binaries
- No package manager (`apk del`, `rm -rf /var/cache/apk/*`)
- Pin all image tags to digest (`:sha256:...`)

### 2. Runtime Security
- Use security profiles: `seccomp`, `AppArmor`, `SELinux`
- Drop all capabilities, add only required (`--cap-drop ALL --cap-add NET_BIND_SERVICE`)
- Enable no-new-privileges flag
- Scan images: `trivy image --severity HIGH,CRITICAL` in CI
- Fail build on CRITICAL CVEs

### 3. Kubernetes Security (if applicable)
- Use NetworkPolicies (deny all, allow only needed)
- Run with least-privilege ServiceAccount
- Enable Pod Security Standards (Restricted profile)
- Use `RunAsNonRoot: true`, `ReadOnlyRootFilesystem: true`
- Scan YAML manifests with `kubesec`, `checkov`

## TLS / HTTPS Checklist

### 1. Certificate Management
- Use ACME/Let's Encrypt with cert-manager (automatic renewal)
- Fallback: AWS ACM or GCP Cloud DNS managed certificates
- Wildcard certs via DNS-01 challenge
- Redirect HTTP → HTTPS (always)
- HSTS preload for production domains

### 2. TLS Configuration
- Minimum TLS 1.2, prefer TLS 1.3
- Disable SSLv3, TLS 1.0, TLS 1.1
- Strong cipher suite (AES-256-GCM, ChaCha20)
- Certificate public key ≥ 2048-bit RSA or 256-bit ECDSA
- Test with `testssl.sh` or SSL Labs

## Output Format

```
## 🔐 DevSecOps Setup — [Context]

### Secret Management
- Provider: ...
- Injection method: ...
- Rotation policy: ...

### Container Hardening
- Base image: ...
- User: non-root
- Capabilities: dropped all / added: ...
- CVE scan: ...

### TLS
- Provider: ...
- Min version: TLS 1.2/1.3
- Renewal: automated (cert-manager) / manual

### Monitoring
- Secret access audit: ...
- Anomaly detection: ...

### Runbook Links
- Secret rotation: ...
- Certificate renewal: ...
- Incident response: ...
```
