# API Spec (OpenAPI)

## Description

Expert in designing and documenting REST/GraphQL APIs using OpenAPI 3.x and Swagger. Generates clean, complete API specs that serve as a single source of truth for both frontend-backend synchronization and developer onboarding.

## Triggered When

- User says "design API", "document API", "write OpenAPI spec"
- User says "thiết kế API spec", "viết OpenAPI", "tài liệu API", "Swagger"
- User asks "what should this endpoint look like" or "is this RESTful"
- User says "endpoint này RESTful không", "thiết kế API documentation"
- User asks about API versioning, pagination, error formats, or authentication
- User wants to generate SDKs, mock servers, or contract tests from spec

## API Design Checklist

### 1. URL Structure (REST)
```
✅ Good:  GET  /users/{id}/orders
✅ Good:  POST /articles/{slug}/comments
❌ Bad:   GET  /getUser?id=123
❌ Bad:   POST /api/v1/users/active/list
```
- Use nouns, not verbs: `/orders` not `/getOrders`
- Use kebab-case: `/order-items` not `/orderItems`
- Nest resources max 2 levels deep: `/users/{id}/orders` (good) — deeper = anti-pattern
- Version in URL: `/v1/`, `/v2/` (simple, visible, cacheable)

### 2. HTTP Methods
```
GET    — retrieve (safe, idempotent)
POST   — create
PUT    — replace (idempotent)
PATCH  — partial update (idempotent)
DELETE — remove (idempotent)
```
- Use 200 for success (with body), 204 for success (no body)
- Return created resource on POST 201 (include Location header)

### 3. Request & Response Format
```json
// Request (content-type: application/json)
{
  "email": "user@example.com",
  "name": "Alice"
}

// Response
{
  "data": {
    "id": "usr_01HX...",
    "email": "user@example.com",
    "name": "Alice",
    "createdAt": "2026-04-07T10:00:00Z"
  }
}
```

### 4. Error Format (standardize across all endpoints)
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email is required",
    "details": [
      { "field": "email", "issue": "required" }
    ]
  }
}
```
- Always include `code` (machine-readable) + `message` (human-readable)
- Map HTTP status to error type:
  - 400: validation / bad request
  - 401: unauthenticated
  - 403: unauthorized (no permission)
  - 404: not found
  - 409: conflict (duplicate)
  - 422: semantic validation error
  - 429: rate limited
  - 500: internal server error

### 5. Pagination
```
GET /articles?page=1&limit=20
```
Response:
```json
{
  "data": [...],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 342,
    "totalPages": 18,
    "nextCursor": "cur_abc123"
  }
}
```
- Prefer cursor-based pagination for large datasets (performance)
- Use offset-based only when "jump to page" is needed UX

### 6. Authentication
- Bearer token in `Authorization` header: `Authorization: Bearer <token>`
- Refresh token: separate endpoint `POST /auth/refresh`
- Document required scopes per endpoint: `securitySchemes`

## OpenAPI 3.x Spec Structure

```yaml
openapi: 3.0.3
info:
  title: [App] API
  version: 1.0.0
  description: |
    Brief description. Link to docs.

servers:
  - url: https://api.app.com/v1
    description: Production
  - url: https://staging-api.app.com/v1
    description: Staging

paths:
  /articles:
    get:
      summary: List articles
      tags: [Articles]
      parameters:
        - $ref: '#/components/parameters/Page'
        - $ref: '#/components/parameters/Limit'
      responses:
        '200':
          description: Success
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ArticleList'
    post:
      summary: Create article
      security: [{ BearerAuth: [] }]
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateArticle'
      responses:
        '201':
          description: Created
          headers:
            Location:
              schema: { type: string }
              example: /v1/articles/art_xyz
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Article'

components:
  schemas:
    Article:
      type: object
      properties:
        id: { type: string, example: 'art_xyz' }
        title: { type: string }
        publishedAt: { type: string, format: date-time }
    CreateArticle:
      type: object
      required: [title]
      properties:
        title: { type: string }
        body: { type: string }

  securitySchemes:
    BearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT

  parameters:
    Page: { name: page, in: query, schema: { type: integer, default: 1 } }
    Limit: { name: limit, in: query, schema: { type: integer, default: 20 } }
```

## Output Format

```
## 📡 API Spec — [EndpointGroup]

### Endpoints
| Method | Path | Auth | Description |
|---|---|---|---|
| GET | /articles | No | List articles |
| POST | /articles | Yes | Create article |

### [Endpoint Name]
Request:
- Headers: ...
- Body: ...

Response:
- 200: ...
- 400: ...
- 401: ...

### Data Model
\`\`\`yaml
# OpenAPI schema snippet
\`\`\`
```

## Rules

- Every endpoint needs: summary, parameters, all possible response codes
- Use `$ref` to reuse schemas (DRY)
- Document examples for all request/response bodies
- Keep backward compatibility within a major version (v1)
- Use `x-` extensions sparingly for custom metadata (client lib hints, etc.)
