# API Error Handling

## Description

Standardizes error responses across the entire API. Produces consistent, informative error payloads with proper HTTP status codes, logging, and graceful degradation patterns for NestJS and generic Node.js backends.

## Triggered When

- User says "handle this error", "error response", "error format"
- User says "xử lý lỗi", "format lỗi", "trả lỗi kiểu gì"
- User encounters an unhandled exception
- User asks "what status code for this", "error logging", "mã lỗi nào cho trường hợp này"
- Designing a new error type or exception filter
- User says "API crashes on invalid input", "missing error handling", "lỗi 500"

## Standard Error Response Format

### Always return this structure
```json
{
  "statusCode": 400,
  "error": "BadRequest",
  "message": "Validation failed",
  "details": [
    {
      "field": "email",
      "message": "must be a valid email address"
    }
  ],
  "timestamp": "2026-04-07T10:30:00.000Z",
  "path": "/api/users"
}
```

### Response body rules
- **`statusCode`**: matches HTTP status code exactly
- **`error`**: machine-readable error name (PascalCase)
- **`message`**: human-readable summary (don't leak internals)
- **`details`**: optional array for validation errors
- **`timestamp`**: ISO 8601 UTC
- **`path`**: the request URL that caused the error

### NEVER expose in error responses
- Stack traces (in production)
- Internal file paths
- Database query details
- Library names or versions
- Internal variable values

## Error Classification

| Condition | Status | Error type | Example message |
|---|---|---|---|
| Invalid input | `400` | `BadRequest` | "email must be a valid address" |
| Missing auth token | `401` | `Unauthorized` | "Authentication required" |
| Valid token, no permission | `403` | `Forbidden` | "You do not have permission" |
| Resource not found | `404` | `NotFound` | "User with id '...' not found" |
| Duplicate resource | `409` | `Conflict` | "Email already registered" |
| Validation failed | `422` | `UnprocessableEntity` | "Insufficient balance" |
| Rate limit exceeded | `429` | `TooManyRequests` | "Rate limit exceeded, retry after 60s" |
| Server error | `500` | `InternalServerError` | "An unexpected error occurred" |

## NestJS Implementation

### Custom Exception Filter
```typescript
// filters/http-exception.filter.ts
import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { Request, Response } from 'express';

@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    let status = HttpStatus.INTERNAL_SERVER_ERROR;
    let message = 'An unexpected error occurred';
    let error = 'InternalServerError';
    let details: unknown[] | undefined;

    if (exception instanceof HttpException) {
      status = exception.getStatus();
      const body = exception.getResponse();
      if (typeof body === 'object' && body !== null) {
        message = (body as any).message ?? message;
        error = (body as any).error ?? this.toPascalCase(exception.name);
        details = (body as any).details;
      } else {
        message = String(body);
      }
    }

    // Log server errors
    if (status >= 500) {
      console.error({
        timestamp: new Date().toISOString(),
        path: request.url,
        method: request.method,
        status,
        exception,
      });
    }

    response.status(status).json({
      statusCode: status,
      error,
      message,
      details,
      timestamp: new Date().toISOString(),
      path: request.url,
    });
  }

  private toPascalCase(str: string) {
    return str.replace(/([A-Z])/g, ' $1').trim().split(' ').map(
      w => w.charAt(0).toUpperCase() + w.slice(1)
    ).join('');
  }
}
```

### Application-Level Errors
```typescript
// errors/application-errors.ts
export class ApplicationError extends Error {
  constructor(
    public readonly code: string,
    message: string,
    public readonly statusCode: number = 500,
    public readonly details?: unknown[],
  ) {
    super(message);
    this.name = 'ApplicationError';
  }
}

// Usage
throw new ApplicationError('INSUFFICIENT_BALANCE', 'Insufficient balance', 422);
```

## Logging Strategy

### Log levels by environment

| Level | When | Example |
|---|---|---|
| `error` | Server errors (5xx) | DB connection failure, unhandled promise |
| `warn` | Recoverable issues | Rate limit hit, 4xx with business logic failure |
| `info` | Key events | Server start, API request completed |
| `debug` | Development only | Request body, query params |

### Structured log format
```json
{
  "level": "error",
  "timestamp": "2026-04-07T10:30:00.000Z",
  "service": "api-gateway",
  "traceId": "abc-123",
  "path": "/api/orders",
  "method": "POST",
  "statusCode": 500,
  "duration": 234,
  "error": { "message": "...", "stack": "..." }
}
```

## Output Format

```
## API Error Handling — [Context]

### Error Type
- **Status**: [code]
- **Error key**: [PascalCase name]
- **When triggered**: ...

### Response Shape
\`\`\`json
{ ... }
\`\`\`

### NestJS Implementation
\`\`\`typescript
[code]
\`\`\`

### Logging Required?
[Yes/No — what to log]
```

## Rules

- Always return the same error structure across ALL endpoints
- Never expose stack traces or internals in production
- Log 5xx errors with full context for debugging
- Define custom application errors for business logic failures
- Use 422 for semantic/validation errors beyond DTO validation
