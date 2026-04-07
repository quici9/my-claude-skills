# Cloud Architecture

## Description

Expert in designing cloud architecture on AWS and GCP. Covers compute, storage, networking, IAM, cost optimization, and multi-environment setup with clear, cost-aware recommendations.

## Triggered When

- User asks "setup AWS/GCP", "design cloud architecture", "migrate to cloud"
- User says "thiết kế kiến trúc cloud", "setup AWS", "setup GCP", "lên cloud"
- User asks about EC2 vs Lambda, S3 vs RDS, VPC design, or load balancing
- User says "EC2 hay Lambda", "S3 hay RDS", "VPC", "load balancing"
- User asks "how to reduce cloud costs" or "best setup for this use case"
- User says "giảm chi phí cloud", "tối ưu cloud", "cloud architecture"
- User asks about IAM roles, permissions, or cross-account access
- User asks about scaling, high availability, or disaster recovery

## Architecture Decision Tree

```
Use Case:
├── Static site / SPA         → S3/CloudFront (AWS) or Cloud Run (GCP)
├── Server-rendered app       → ECS/Fargate or Cloud Run
├── Heavy compute / long run  → EC2/ECS or GCP Compute Engine
├── Event-driven / serverless → Lambda + EventBridge or Cloud Functions
├── ML training              → SageMaker or Vertex AI
├── Data pipeline            → ECS + S3 + RDS or Cloud Composer
```

## AWS Architecture Checklist

### 1. Compute
- Use Fargate for containers (no EC2 management)
- Lambda for event-driven, short-lived tasks
- Auto Scaling: follow patterns (target tracking vs step scaling)
- No long-running tasks on Lambda (use ECS)

### 2. Networking
- VPC with public/private subnets (at least 2 AZs)
- NAT Gateway for private subnet outbound
- Application Load Balancer for HTTP/HTTPS traffic
- CloudFront for global caching, WAF integration
- Security Groups: minimum required ports, least-privilege source
- No direct public IP on compute (use ALB/NAT)

### 3. Storage & Database
- S3 with lifecycle policies (move to IA/Glacier after 90 days)
- RDS with Multi-AZ for production; snapshots automated
- ElastiCache (Redis) for session/cache when latency critical
- Never store secrets in S3 or environment variables

### 4. IAM & Security
- Use IAM roles, not access keys on EC2/instances
- OIDC/Workload Identity for CI/CD (no long-lived keys)
- AWS Managed Policies as baseline, custom policies for least privilege
- SCPs (Service Control Policies) for organization-level guardrails
- CloudTrail enabled for audit logging

### 5. Cost Optimization
- Cost Explorer → identify top spenders
- Savings Plans or Reserved Instances for steady-state workloads
- Spot instances for batch/ML training (interruptible)
- Delete unused resources (EBS volumes, Elastic IPs, old AMIs)
- Set budget alerts at 80% of expected spend

## GCP Architecture Checklist

### 1. Compute
- Cloud Run for stateless HTTP services (scale to zero = cost saving)
- GKE Autopilot for stateful/mission-critical workloads
- Compute Engine only when specific requirements (GPU, very specific config)

### 2. Networking
- VPC with subnets, Firewall rules (least-privilege)
- Cloud Load Balancing (global HTTP(S) LB recommended)
- Cloud CDN for static assets
- VPC Service Controls for data exfiltration protection

### 3. IAM
- Workload Identity (no service account keys)
- Custom service accounts per service (least privilege)
- Audit Logs enabled for all projects

### 4. Cost Optimization
- Committed Use Discounts for predictable usage
- Labels on all resources for cost attribution
- Budget alerts via Billing Alerts

## Multi-Environment Setup

| Environment | Purpose | Persistence | Approval |
|---|---|---|---|
| `dev` | Development | Ephemeral (delete weekly) | Auto-deploy on PR |
| `staging` | Pre-prod testing | Semi-permanent | Auto-deploy on merge to main |
| `prod` | Production | Permanent, backed up | Manual approval only |

- Separate AWS accounts / GCP projects per environment
- Use Infrastructure-as-Code (Terraform / Pulumi / CDK)
- No manual console changes (drift = disaster)

## Output Format

```
## ☁️ Cloud Architecture — [AppName]

### Stack Summary
- Provider: AWS / GCP
- Region: ...
- Environments: dev / staging / prod (separate accounts?)

### Compute
- Service: ...
- Scaling: ...
- Instance/container size: ...

### Networking
- VPC: ...
- Public facing: ALB / Cloud LB
- Internal: ...

### Data
- Storage: ...
- Database: ...
- Cache: ...

### IAM
- Service accounts / roles: ...
- CI/CD auth: OIDC / Workload Identity

### Cost Estimate (monthly)
- Compute: ...
- Storage: ...
- Networking: ...
- Total: ~$XX

### IaC
- Tool: Terraform / Pulumi / CDK
- Repo: ...
```

## Rules

- Always use IaC (no manual console setup)
- Separate environments via accounts/projects, not just tags
- Cost-aware by default: recommend scale-to-zero where possible
- Use managed services to reduce operational burden