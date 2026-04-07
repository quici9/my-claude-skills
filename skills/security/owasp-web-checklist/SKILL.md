# OWASP Web Checklist

## Description

Pre-deployment security review against the OWASP Top 10 (2021). Systematic checklist to identify vulnerabilities in web applications before production release. Covers injection, auth failures, XSS, IDOR, misconfiguration, and more. Run before every deploy.

## Triggered When

- User says "OWASP review", "security checklist", "check before deploy"
- User says "kiểm tra bảo mật", "check OWASP", "review bảo mật trước deploy"
- Pre-release security audit
- User says "is this vulnerable", "security check", "pentest", "có lỗ hổng bảo mật không"
- After adding a new feature or dependency
- User asks "is this secure", "what security issues", "bảo mật không"

## OWASP Top 10 (2021) — Full Checklist

### 1. A01 — Broken Access Control ⭐ CRITICAL
- [ ] Users can access only their own data (vertical + horizontal)
- [ ] API endpoints enforce authorization at every layer
- [ ] Direct object references (IDs) are validated against the current user
- [ ] CORS policy is explicit, not `*` for sensitive APIs
- [ ] Admin routes require admin role, not just auth
- [ ] Rate limiting on all endpoints
- [ ] File access restricted to authorized users

### 2. A02 — Cryptographic Failures
- [ ] No sensitive data in URLs (tokens, passwords, IDs)
- [ ] Passwords hashed with bcrypt/argon2 (not MD5/SHA1)
- [ ] No sensitive data in logs (tokens, full credit cards)
- [ ] TLS enforced on all connections (HTTPS, HSTS header)
- [ ] Encryption keys stored in env vars or secret manager, not in code

### 3. A03 — Injection ⭐ CRITICAL
- [ ] User input validated server-side (never trust client-side only)
- [ ] Parameterized queries used everywhere (no string concatenation in SQL)
- [ ] ORM used instead of raw SQL (or parameterized raw SQL)
- [ ] HTML/escape output for XSS prevention
- [ ] No `eval()`, `new Function()`, `innerHTML` with user input
- [ ] Command injection: never pass user input to system shell commands
- [ ] LDAP/ORM injection: input sanitized for context

### 4. A04 — Insecure Design
- [ ] Threat modeling done for new features
- [ ] Rate limiting on auth endpoints (login, register, password reset)
- [ ] Account lockout after X failed attempts
- [ ] CAPTCHA on sensitive actions (if applicable)
- [ ] No security by obscurity (keys/algorithms not hidden, just protected)

### 5. A05 — Security Misconfiguration
- [ ] Default credentials changed/removed
- [ ] Unnecessary features/ports disabled
- [ ] Error messages don't reveal stack traces or internal paths
- [ ] `X-Content-Type-Options: nosniff` header set
- [ ] `X-Frame-Options: DENY` or `SAMEORIGIN` header set
- [ ] Server version headers hidden
- [ ] Directory listing disabled
- [ ] Debug mode OFF in production
- [ ] Cloud storage buckets not publicly accessible (if applicable)

### 6. A06 — Vulnerable & Outdated Components
- [ ] `npm audit` / `pip-audit` / `cargo audit` run, no high/critical CVEs
- [ ] Dependencies updated within last 90 days
- [ ] No known vulnerable libraries (check cvedb.com)
- [ ] Third-party scripts/CDNs reviewed for supply chain risks

### 7. A07 — Identification & Authentication Failures
- [ ] JWT tokens have expiration (max 15 min for access, 7 days for refresh)
- [ ] JWT secret is strong (min 256-bit), stored securely
- [ ] Refresh token rotation implemented
- [ ] Password policy enforced: min 8 chars, complexity (or passphrase)
- [ ] No "remember me" using permanent tokens
- [ ] Session IDs regenerated after login
- [ ] Sessions invalidated on logout (server-side)
- [ ] Session timeout enforced (30 min idle)

### 8. A08 — Software & Data Integrity Failures
- [ ] CI/CD pipeline has security scanning (SAST, DAST, dependency scan)
- [ ] No untrusted CDNs or scripts without SRI (Subresource Integrity)
- [ ] Docker images from official/reviewed sources only
- [ ] No auto-update from untrusted sources

### 9. A09 — Security Logging & Monitoring Failures
- [ ] Failed login attempts logged with IP, user, timestamp
- [ ] Access control failures logged
- [ ] Server-side input validation failures logged
- [ ] All errors logged server-side (not exposed to client)
- [ ] Logs have structured format (JSON, not plain text)
- [ ] Alerting set up for suspicious patterns (> X failed logins/minute)
- [ ] No sensitive data in logs (tokens cleared)

### 10. A10 — Server-Side Request Forgery (SSRF)
- [ ] User-provided URLs validated before fetching
- [ ] URL scheme restricted (no `file://`, `dict://`, `gopher://`)
- [ ] Allowlist for external APIs, deny by default
- [ ] Response validation before returning to user

## Quick Scan Output

```
## OWASP Checklist — [App Name / Feature]

### CRITICAL (must fix before deploy)
- [ ] A01 Access Control: [issue / ✅ OK]
- [ ] A03 Injection: [issue / ✅ OK]

### HIGH
- [ ] A02 Crypto: [issue / ✅ OK]
- [ ] A07 Auth: [issue / ✅ OK]

### MEDIUM
- [ ] A04 Insecure Design: [issue / ✅ OK]
- [ ] A05 Misconfiguration: [issue / ✅ OK]

### LOW / INFO
- [ ] A06 Components: [status]
- [ ] A09 Logging: [status]

### Overall: 🟢 APPROVE / 🟡 REVIEW / 🔴 BLOCK DEPLOY
```

## Rules

- **CRITICAL items must be fixed before any deploy to production**
- Run this checklist at minimum: before first deploy, before each major release
- Keep evidence of checklist completion (screenshot, comment in PR)
- Use automated tools (OWASP ZAP, Snyk, npm audit) in CI/CD alongside this checklist