# API Security Hardening

## Description

Hardens REST APIs against common web attacks — CORS misconfiguration, CSRF, injection, rate limiting, request smuggling, and HTTP header security. Provides production-ready middleware configurations for NestJS, Express, and generic Node.js.

## Triggered When

- User says "harden API", "secure headers", "CORS setup"
- User says "bảo mật API", "tăng cường security", "CORS setup"
- User asks about "rate limiting", "CSRF", "request validation", "giới hạn request"
- Pre-deployment security hardening
- User says "input sanitization", "XSS protection", "DDOS protection", "bảo vệ XSS"
- Setting up API security for a new project

## HTTP Security Headers

```typescript
// helmet — set all recommended security headers
import helmet from 'helmet';

// In Express / NestJS
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'", "'nonce-{generated}'"],
      styleSrc: ["'self'", "'unsafe-inline'"],  // remove unsafe-inline in CSP
      imgSrc: ["'self'", 'data:', 'https:'],
      connectSrc: ["'self'"],
      fontSrc: ["'self'"],
      objectSrc: ["'none'"],
      mediaSrc: ["'self'"],
      frameSrc: ["'none'"],
    },
  },
  crossOriginEmbedderPolicy: false,  // disable if using shared workers
}));

// Individual headers
app.use((req, res, next) => {
  // Prevent MIME type sniffing
  res.setHeader('X-Content-Type-Options', 'nosniff');

  // Prevent clickjacking
  res.setHeader('X-Frame-Options', 'DENY');

  // Force HTTPS (only if HTTPS is configured)
  res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains; preload');

  // Referrer policy
  res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');

  // Permissions policy
  res.setHeader('Permissions-Policy', 'geolocation=(), microphone=(), camera=()');

  next();
});
```

## CORS Configuration

```typescript
// ✅ CORRECT — Explicit allowlist
app.use(cors({
  origin: [
    'https://app.example.com',
    'https://admin.example.com',
  ],
  credentials: true,  // allows cookies / auth headers
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  maxAge: 86400,     // cache preflight for 24h
}));

// ❌ NEVER DO THIS — Wide open CORS
app.use(cors({
  origin: '*',  // bypasses Same-Origin Policy
  credentials: true,  // DANGEROUS with origin: '*'
}));
```

## Rate Limiting

```typescript
// NestJS — @nestjs/throttler
app.useGlobalGuards(
  new ThrottlerGuard({
    ttl: 60000,     // 1 minute window
    limit: 60,      // max 60 requests per window (general)
  }),
);

// Per-route rate limiting
@UseGuards(ThrottlerGuard)
@Throttle({ default: { limit: 10, ttl: 60000 } })  // stricter
@Controller('auth')
export class AuthController {
  @Post('login')
  @Throttle({ login: { limit: 5, ttl: 60000 } })  // 5 attempts/min
  async login(@Body() dto: LoginDto) { ... }

  @Post('register')
  @Throttle({ register: { limit: 3, ttl: 60000 } })  // 3 attempts/min
  async register(@Body() dto: RegisterDto) { ... }
}
```

### Express rate limiter
```typescript
import rateLimit from 'express-rate-limit';

const globalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,  // 15 minutes
  max: 100,                   // 100 requests per IP per window
  standardHeaders: true,     // Return rate limit info in headers
  legacyHeaders: false,
  message: { error: 'Too many requests', retryAfter: 60 },
});

const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5,                    // Very strict for auth endpoints
  skipSuccessfulRequests: true,  // Only count failed attempts
  message: { error: 'Too many authentication attempts' },
});

app.use('/api', globalLimiter);
app.use('/api/auth', authLimiter);
```

## Input Sanitization

```typescript
import validator from 'validator';

// Always sanitize AND validate
// Validation = "is this valid?" — use class-validator
// Sanitization = "make this safe" — use before storage/output

// HTML sanitization (before rendering, not before storage)
import DOMPurify from 'isomorphic-dompurify';

// Before storing user HTML content
const clean = DOMPurify.sanitize(userProvidedHtml, {
  ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'p', 'br'],
  ALLOWED_ATTR: [],
});

// URL sanitization
if (!validator.isURL(url, { require_protocol: true })) {
  throw new BadRequestException('Invalid URL');
}

// SQL — already covered by parameterized queries (TypeORM/Prisma)
// No raw SQL = no SQL injection risk

// OS command — NEVER pass user input to exec/shell
// If absolutely necessary: use allowlist + shell-escape
import shellEscape from 'shell-escape';
```

## Request Size & Complexity Limits

```typescript
// Prevent large payload attacks
app.use(express.json({ limit: '100kb' }));       // max request body
app.use(express.urlencoded({ extended: true, limit: '100kb' }));
app.use(express.text({ limit: '100kb' }));

// NestJS — main.ts
app.useGlobalPipes(new ValidationPipe({
  whitelist: true,
  forbidNonWhitelisted: true,
  // class-transformer handles size limits
}));

// Limit file upload size
// multer: limits: { fileSize: 5 * 1024 * 1024 }  // 5MB max
```

## HTTP Request Smuggling Prevention

```typescript
// Disable proxy caching headers that can be exploited
app.use((req, res, next) => {
  res.setHeader('Connection', 'close');  // prevents keep-alive smuggling
  next();
});

// For Node.js behind a proxy — trust proxy setting
app.set('trust proxy', 1);  // trust first proxy only

// Ensure all servers in the chain use the same protocol
// Misconfigured proxies are the main cause of smuggling vulnerabilities
```

## Security Checklist

- [ ] Helmet.js middleware enabled
- [ ] CORS origin allowlist configured (no `*` for credentials)
- [ ] Rate limiting on all endpoints (strict on auth)
- [ ] Request body size limited (≤ 100KB typical)
- [ ] Input validation on all endpoints (whitelist mode)
- [ ] XSS sanitization on user-generated HTML content
- [ ] `trust proxy` set correctly (1, not `true`)
- [ ] No verbose error pages (disable in production)
- [ ] Security headers set (HSTS, CSP, X-Frame-Options)
- [ ] TLS 1.2+ enforced (disable older protocols)

## Output Format

```
## API Security Hardening — [Context]

### Security Headers
\`\`\`
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
Strict-Transport-Security: max-age=31536000
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: ...
\`\`\`

### Rate Limiting
\`\`\`typescript
[config]
\`\`\`

### Sanitization Rules
- [x] HTML content (DOMPurify)
- [x] URL input (validator)
- [x] Request body limit: Xmb

### Overall: 🟢 HARDENED / 🟡 REVIEW / 🔴 ISSUES FOUND
```

## Rules

- NEVER disable security headers for "development convenience" without understanding the risk
- Rate limiting must be STRICTER on auth endpoints (login, register, password reset)
- Never store raw user HTML — always sanitize on output, not on input
- Use `helmet` as a baseline — add custom headers on top, not instead
- `trust proxy` must be set correctly when behind a reverse proxy
- All production APIs MUST use HTTPS with TLS 1.2+