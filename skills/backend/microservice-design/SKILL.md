# Microservice Design

## Description

Architects multi-service distributed systems with clear boundaries, inter-service communication patterns, and message queue design. Helps define service boundaries, API contracts, and deployment topology for scalable backends.

## Triggered When

- User says "split into microservices", "design service boundaries"
- User says "tách microservice", "thiết kế service", "kiến trúc phân tán"
- User asks about "message queue", "event-driven", "service communication"
- User says "message queue", "event bus", "async communication", "rabbitmq", "kafka"
- Planning a large system refactor or new platform
- User says "API gateway", "event bus", "async communication"

## Service Boundary Design

### Principles
1. **Single Responsibility** — one service does one domain well
2. **Low Coupling** — services communicate via contracts, not shared DB
3. **High Cohesion** — related functionality lives in the same service
4. **Database per Service** — never share a database between services

### Common Service划分

```
✅ Good boundaries:
├── auth-service        → Users, sessions, tokens
├── billing-service     → Payments, invoices, subscriptions
├── notification-service → Email, push, SMS
├── order-service       → Orders, cart, checkout
└── product-service     → Products, catalog, inventory

❌ Bad boundaries (too fine-grained):
├── user-create-service
├── user-read-service
├── user-update-service
```

### Anti-patterns to avoid
- `shared-database` pattern (services share DB tables)
- `distributed monolith` (services call each other synchronously for everything)
- `god-service` (one service does everything)

## Communication Patterns

### 1. Synchronous (HTTP/gRPC)
Use for: queries, read-heavy operations, low latency requirements

```
Client → API Gateway → User Service → Response
                        ↕
                        → Order Service → Response
```

### 2. Asynchronous (Message Queue)
Use for: background jobs, cross-service events, fan-out notifications

```
User Service publishes "user.created"
  → Queue
    → Notification Service (send welcome email)
    → Analytics Service (record event)
    → Billing Service (create account)
```

### 3. Event-Driven Architecture
Use for: decoupled workflows, audit logs, multi-consumer events

```typescript
// Event definition
interface UserCreatedEvent {
  eventId: string;      // UUID
  eventType: 'user.created';
  timestamp: string;   // ISO 8601
  payload: {
    userId: string;
    email: string;
    name: string;
  };
}

// Publisher (in UserService)
await this.eventBus.publish('user.created', event);

// Subscriber (in NotificationService)
@EventHandler('user.created')
async handle(event: UserCreatedEvent) {
  await this.emailService.sendWelcome(event.payload.email);
}
```

## Message Queue Design

### When to use which queue

| Queue | Use for | Not for |
|---|---|---|
| RabbitMQ | Task queues, routing patterns | High-throughput streams |
| Kafka | Event streaming, audit logs, replay | Simple task queues |
| Redis Streams | Simple queues, moderate throughput | Multi-consumer, long retention |
| SQS (AWS) | Fully managed, simple queues | Low latency (< 100ms) |

### Queue naming convention
```
{exchange}.{service}.{action}

Examples:
notifications.email.send
orders.payment.process
users.auth.login
```

### Dead Letter Queue (DLQ) setup
Every queue MUST have a DLQ:
```
notifications.email.send          → notifications.email.send.dlq
notifications.email.send.retry    → notifications.email.send.dlq
```

## API Gateway Pattern

```typescript
// Gateway routes
const routes = [
  { path: '/api/auth/*',   service: 'auth-service',        port: 3001 },
  { path: '/api/users/*',  service: 'user-service',        port: 3002 },
  { path: '/api/orders/*', service: 'order-service',       port: 3003 },
  { path: '/api/products/*', service: 'product-service',   port: 3004 },
];

// Gateway responsibilities:
// - Authentication (JWT validation) — don't pass raw token to services
// - Rate limiting (per user, per service)
// - Request logging
// - Circuit breaker for downstream services
// - Response caching (optional)
```

## Service Contract (Contract-First Design)

```yaml
# contracts/user-service.yaml
openapi: 3.0.3
info:
  title: User Service API
  version: 1.0.0

paths:
  /users:
    get:
      summary: List users
      responses:
        '200':
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserList'
```

## Deployment Topology

```
                    [Load Balancer]
                          |
                    [API Gateway]
                    /    |    \
              [Auth]  [Order]  [Product]
                |        |          |
          [DB/Redis]  [DB]      [DB/S3]
                      |
                 [Message Queue]
                   ↙      ↘
            [Notify]    [Analytics]
```

## Checklist

- [ ] Service boundaries defined by domain, not by layer
- [ ] Each service owns its database (no shared DB)
- [ ] Sync communication used only for real-time queries
- [ ] Async/event communication for cross-domain workflows
- [ ] Every async queue has a DLQ
- [ ] API Gateway handles auth, not services
- [ ] Health check endpoints on every service (`/health`)
- [ ] Service discovery (or fixed ports for small systems)

## Output Format

```
## Microservice Design — [System Name]

### Service Map
| Service | Responsibility | DB | Port |
|---|---|---|---|
| auth | Sessions, tokens | PostgreSQL | 3001 |

### Communication
- Sync: [which services, via what protocol]
- Async: [which events, via what queue]

### Event Schema
\`\`\`typescript
[event definitions]
\`\`\`

### Infrastructure
[docker-compose / k8s manifests]
```

## Rules

- Start monolithic, split only when there is a clear pain point
- Don't split until each potential service has a clearly bounded context
- Use async messaging for anything that doesn't need an immediate response
- Every service must have a health check endpoint
- Version service APIs independently — use semantic versioning