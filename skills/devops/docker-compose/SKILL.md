# Docker & Compose

## Description

Expert in Docker containerization and Docker Compose setup. Creates optimized, secure, production-ready Dockerfiles and compose stacks for Node.js, Python, NestJS, and Next.js applications.

## Triggered When

- User says "dockerize", "create Dockerfile", "setup docker"
- User says "dockerize", "tạo Dockerfile", "docker compose", "container hóa"
- User shares Docker error or build failure
- User says "docker build lỗi", "container không chạy", "Dockerfile tối ưu"
- User asks "how do I optimize my Dockerfile" or "how to use docker-compose for dev/prod"
- User says "multi-stage build", "volume mount", "network docker", "docker networking"

## Dockerfile Checklist

### 1. Multi-stage Build
- **Build stage**: install deps, compile/transpile, run tests
- **Production stage**: copy only runtime artifacts, no dev deps, no source
- Use `-alpine` or `-slim` base images to minimize size
- Name stages (e.g., `FROM node:20-alpine AS builder`)
- Final stage uses non-root user (`addgroup -S app && adduser -S app -G app`)

### 2. Layer Optimization
- Order layers from least to most frequently changing (deps → source → build artifacts)
- `COPY package*.json` first, `RUN npm ci`, then copy source
- Combine RUN commands to reduce layers
- Use `.dockerignore` to exclude `node_modules`, `.git`, `*.log`, `dist`, `coverage`
- Target: final image < 300MB (Node.js), < 150MB (Go/Rust)

### 3. Security
- Never run as root
- No secrets in Dockerfile (use build args or runtime secrets)
- Pin base image versions (`:20` not `:latest`)
- Scan with `trivy image --severity HIGH,CRITICAL [image]`
- Set read-only filesystem where possible (`--read-only`)

### 4. Health & Observability
- Add `HEALTHCHECK` instruction (curl or custom script)
- Expose only necessary ports
- Set `NODE_ENV=production`
- Log to stdout/stderr (not file)

### 5. Common Patterns by Stack
```
Node.js/NestJS:
  - Multi-stage: build → production
  - Port: 3000 or 8080
  - Start: node dist/main.js (not ts-node)

Next.js:
  - Multi-stage: deps → builder → runner
  - Port: 3000
  - Start: next start

Python/FastAPI:
  - Multi-stage: deps → production
  - Port: 8000
  - Start: uvicorn app:app --host 0.0.0.0
```

## Docker Compose Checklist

### 1. Service Definition
- Use `version: '3.9'` or latest
- Name services meaningfully (not `app1`, `app2`)
- Map ports explicitly: `3000:3000` not `- 3000`
- Set resource limits (`cpus`, `mem_limit`)
- Use `restart: unless-stopped` for production services

### 2. Development vs Production
- Use `docker-compose.yml` (base) + `docker-compose.override.yml` (dev) + `docker-compose.prod.yml`
- Dev: bind mounts, hot reload, verbose logs
- Prod: image built externally, no bind mounts, health checks

### 3. Networking
- Define custom network (bridge or overlay)
- Services reference each other by service name (not localhost)
- Expose only public ports on gateway service
- Use internal network for DB/backend services

### 4. Volumes
- Use named volumes for persistent data (DB, uploads)
- Use bind mounts for local dev only
- Backup strategy for named volumes

## Output Format

```
## 🐳 Docker Setup — [AppName]

### Dockerfile Stages
- builder: ...
- runner: ...

### Final Image Size
- Target: < 300MB

### Compose Services
- web: ... ports, limits, health
- db: ... volume, credentials
- redis: ...

### Security Notes
- Running as: non-root user
- Secrets: ...
- Base image: pinned version

### Commands
\`\`\`bash
# Build
docker build -t app:latest .

# Run dev
docker compose up

# Run prod
docker compose -f compose.yml -f compose.prod.yml up -d
\`\`\`
```
