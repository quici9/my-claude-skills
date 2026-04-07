# Monitoring Setup

## Description

Expert in implementing observability stack: structured logging, metrics, tracing, alerting, and dashboards. Covers OpenTelemetry, Prometheus, Grafana, Datadog, CloudWatch, and incident management.

## Triggered When

- User asks "setup monitoring", "add logging", "configure alerting"
- User says "setup monitoring", "thêm logging", "cấu hình alerting", "theo dõi production"
- User asks about metrics, traces, logs, or observability
- User says "metrics", "traces", "logs", "observability", "Prometheus", "Grafana"
- User asks "how to debug a production issue" or "what happened during the outage"
- User says "debug production", "tìm lỗi production", "sự cố production", "outage"
- User asks about SLA/SLO/SLI setup or incident response
- User says "SLO", "SLA", "incident response", "post-mortem", "runbook"

## Three Pillars of Observability

### 1. Logs
- **Structured logging** (JSON): timestamp, level, service, trace_id, user_id, message
- Log levels: ERROR (action needed) / WARN (degraded) / INFO (important events) / DEBUG (detailed)
- Log every request: incoming (request ID), outgoing (correlation ID)
- Never log: passwords, tokens, PII, credit card numbers (use `[REDACTED]`)
- Ship via: Fluentd/Fluent Bit → Elasticsearch or Loki or CloudWatch Logs
- Retention: 30 days hot, 1 year cold (compliance dependent)

### 2. Metrics
- **RED method** (Rate, Errors, Duration) for services:
  - `http_requests_total{method, status, path}` — rate
  - `http_requests_errors_total{method, status, path}` — errors
  - `http_request_duration_seconds{method, path}` — latency histogram
- **USE method** (Utilization, Saturation, Errors) for infrastructure:
  - CPU%, Memory%, Disk I/O, Network
  - Queue depth, connection pool usage
- Collect with: Prometheus client lib, OpenTelemetry, or cloud-native agents
- Scrape interval: 15s (fine for most), 5s (for latency-critical)

### 3. Traces
- Distributed tracing with OpenTelemetry (vendor-neutral)
- Instrument: HTTP calls, DB queries, queue operations, cache ops
- Propagate `trace_id` through all services (W3C Trace Context)
- Sampling: 100% for errors, 1-10% for successful traces (head-based)
- Store in: Jaeger, Tempo (Grafana), or cloud-native (AWS X-Ray, GCP Trace)

## Alerting Checklist

### 1. Define SLO/SLI first
- SLI: what you measure (latency < 500ms, error rate < 1%)
- SLO: target (99.5% availability = 3.7h downtime/month max)
- Error Budget: remaining allowed failure time

### 2. Alert on symptoms, not causes
```
✅ Good: API latency P99 > 2s (user impact)
❌ Bad:  CPU > 80% (cause, might not affect users)

✅ Good: Error rate > 2% for 5 min
❌ Bad:  DB connection pool > 80% (might be fine)
```

### 3. Alert configuration
- **Warning**: SLO at risk (> 1x error budget burn rate)
- **Critical**: SLO breached (> 3x burn rate)
- Min 5 min evaluation period (avoid flapping)
- Require 2+ occurrences before page (avoid noise)
- Auto-resolve alerts when condition clears

### 4. Alert routing
- PagerDuty / Opsgenie for critical (phone + SMS)
- Slack for warnings (no pages)
- Separate routing for business alerts (revenue impacted) vs tech alerts

## Dashboard Design

### Key Dashboards (per service)
1. **Overview**: SLO gauge, error rate, latency P50/P95/P99
2. **Traffic**: RPS, concurrent users,饱和度
3. **Errors**: Error rate by type, error budget consumption
4. **Infrastructure**: CPU, memory, disk, network
5. **External Dependencies**: third-party API latency, error rate

### Best Practices
- Dashboards as code (Grafana JSON, Terraform provider)
- One source of truth: don't duplicate charts
- Use annotations for deploys (overlay vertical lines on graphs)
- Color coding: green/amber/red consistent across all dashboards

## Incident Response

### Runbooks
- Document detection → diagnosis → mitigation → post-mortem for each alert
- Include: symptoms, possible causes, diagnostic commands, mitigation steps
- Keep runbooks up to date after each incident

### Post-Mortem (Blameless)
- Timeline: when did symptom appear vs when detected
- Root cause: not "human error" but "process/system made error possible"
- Action items: specific, assigned, with due dates
- Publish within 48h of incident

## Output Format

```
## 📊 Observability Stack — [AppName]

### Metrics
- Collection: Prometheus / OTEL / CloudWatch
- Key metrics tracked: ...

### Logging
- Format: JSON structured
- Ship: ...
- Retention: ...

### Tracing
- Standard: OpenTelemetry
- Backend: Jaeger / Tempo / X-Ray
- Sampling: X% normal, 100% errors

### Alert Summary
| Alert | Threshold | Severity | Runbook |
|---|---|---|---|
| Latency P99 | > 2s | Critical | link |
| Error Rate | > 2% | Warning | link |

### SLOs
- Endpoint availability: 99.5%
- API latency P99: < 500ms

### Runbooks
- [Incident name]: link
```