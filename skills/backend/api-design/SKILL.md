# API Design

## Description

Designs REST and GraphQL APIs that are consistent, scalable, and easy to consume. Covers resource naming, HTTP methods, status codes, versioning, pagination, and query patterns. Outputs production-ready OpenAPI specs or schema definitions.

## Triggered When

- User says "design an API", "API endpoint", "new feature API"
- User says "thiết kế API", "tạo endpoint", "endpoint này dùng gì"
- User asks "should this be POST or PUT", "what status code", "nên dùng method nào"
- User says "REST API design", "GraphQL schema"
- Planning a new feature or service boundary

## Resource Naming Convention

### Rules
- **Nouns, not verbs** — `/users`, `/orders`, `/products`
- **Plural for collections** — `/users`, not `/user`
- **Hierarchical for relations** — `/users/{id}/orders`
- **Kebab-case** — `/order-items`, not `/orderItems` or `/order_items`
- **No verbs in path** — `/users/search` not `/getUsers`

### Standard HTTP Methods

| Method | Use | Idempotent | Body |
|---|---|---|---|
| `GET` | Read resource(s) | ✅ | No |
| `POST` | Create resource | ❌ | Yes |
| `PUT` | Full replace | ✅ | Yes |
| `PATCH` | Partial update | ❌ | Yes |
| `DELETE` | Remove resource | ✅ | No |

### Standard Status Codes

| Code | Meaning | When |
|---|---|---|
| `200 OK` | Success with body | GET/PUT/PATCH success |
| `201 Created` | Resource created | POST success |
| `204 No Content` | Success, no body | DELETE success |
| `400 Bad Request` | Validation error | Invalid input |
| `401 Unauthorized` | Not authenticated | Missing/invalid token |
| `403 Forbidden` | No permission | Authenticated but not allowed |
| `404 Not Found` | Resource missing | ID not found |
| `409 Conflict` | State conflict | Duplicate, wrong state |
| `422 Unprocessable` | Semantic error | Valid format, invalid logic |
| `429 Too Many Requests` | Rate limited | Exceeded limit |
| `500 Internal Server Error` | Server error | Unexpected failure |

## Pagination

### Cursor-based (recommended for large datasets)
```
GET /orders?cursor=eyJpZCI6MTIzfQ&limit=20

Response:
{
  "data": [...],
  "pagination": {
    "nextCursor": "eyJpZCI6MTQzfQ",
    "hasMore": true
  }
}
```

### Offset-based (for small/moderate datasets)
```
GET /orders?page=2&per_page=20

Response:
{
  "data": [...],
  "pagination": {
    "page": 2,
    "perPage": 20,
    "total": 340,
    "totalPages": 17
  }
}
```

## Filtering & Sorting

```
GET /orders?status=pending&sort=created_at:desc&fields=id,status,total
```

Use **shallow fields** for list endpoints:
- List: `id, status, total, created_at` (no nested objects)
- Detail: full object with relations

## API Design Checklist

- [ ] Resources identified — noun-based paths, plural
- [ ] Methods correct — GET/POST/PUT/PATCH/DELETE
- [ ] Status codes correct — 200/201/204/400/401/403/404
- [ ] Naming consistent — kebab-case throughout
- [ ] Pagination included — cursor or offset
- [ ] Filtering & sorting documented
- [ ] Error response format standardized
- [ ] Authentication noted (Bearer token, API key)
- [ ] Rate limits documented

## Output Format

```
## API Design — [Resource/Feature]

### Endpoints

#### POST /{resource}
**Request**
```json
{ ... }
```
**Response** `201 Created`
```json
{ ... }
```

#### GET /{resource}
**Query params**: ...
**Response** `200 OK`
```json
{ ... }
```

### Data Model
| Field | Type | Required | Notes |
|---|---|---|---|
| id | uuid | auto | |

### OpenAPI / GraphQL Schema (optional)
\`\`\`yaml
[or graphql schema]
\`\`\`
```

## Rules

- Always prefer REST for CRUD, GraphQL for flexible queries
- Never return `200` for errors — use correct 4xx/5xx
- Document auth on every endpoint
- Design for the consumer first, not the database
