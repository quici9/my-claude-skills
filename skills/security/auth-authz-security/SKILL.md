# Auth & AuthZ Security

## Description

Implements secure authentication (JWT access + refresh token rotation) and authorization (RBAC) for NestJS and generic Node.js backends. Covers password hashing, token storage, session invalidation, role management, and defensive patterns against auth attacks.

## Triggered When

- User says "add JWT auth", "implement login", "refresh token"
- User says "thêm authentication", "implement login", "JWT token", "đăng nhập"
- User asks about "RBAC", "role permissions", "access control", "phân quyền"
- User says "password hashing", "bcrypt", "JWT security"
- User asks "how to handle session", "logout", "token rotation", "quản lý session"
- Designing auth system for a new application

## Authentication Flow

```
Login Flow:
Client → POST /auth/login (email + password)
       ← { accessToken, refreshToken }

Request Flow:
Client → GET /api/resource (Authorization: Bearer <accessToken>)
       ← { data }

Refresh Flow:
Client → POST /auth/refresh (refreshToken)
       ← { accessToken, refreshToken (new) }  ← rotation

Logout Flow:
Client → POST /auth/logout
       ← { success }
```

## Password Hashing

```typescript
// Use bcrypt or argon2 — NEVER hash with MD5, SHA1, or plain

import * as bcrypt from 'bcrypt';

const SALT_ROUNDS = 12;

async function hashPassword(password: string): Promise<string> {
  return bcrypt.hash(password, SALT_ROUNDS);
}

async function verifyPassword(
  password: string,
  hash: string,
): Promise<boolean> {
  return bcrypt.compare(password, hash);
}

// Argon2 (better, but slower — use for high-security apps)
import argon2 from 'argon2';

const hash = await argon2.hash(password);
const valid = await argon2.verify(hash, password);
```

## JWT Token Structure

```typescript
// Access Token (short-lived: 15 minutes)
{
  sub: 'user-uuid-123',
  email: 'user@example.com',
  role: 'admin',
  type: 'access',
  iat: 1712500000,
  exp: 1712500900  // 15 min
}

// Refresh Token (long-lived: 7 days)
{
  sub: 'user-uuid-123',
  type: 'refresh',
  jti: 'refresh-token-uuid',  // unique ID for revocation
  iat: 1712500000,
  exp: 1713100000  // 7 days
}
```

### JWT Configuration
```typescript
// Access token
{
  secret: process.env.JWT_ACCESS_SECRET!,   // min 256-bit random
  expiresIn: '15m',
  algorithm: 'HS256',
}

// Refresh token
{
  secret: process.env.JWT_REFRESH_SECRET!,
  expiresIn: '7d',
  algorithm: 'HS256',
}
```

## Token Storage & Rotation

### Refresh Token Storage (Database)
```typescript
// entities/refresh-token.entity.ts
@Entity('refresh_tokens')
export class RefreshToken {
  @PrimaryColumn('uuid')
  id: string;           // jti — token ID

  @Column('uuid')
  userId: string;

  @Column('timestamptz')
  expiresAt: Date;

  @Column('boolean', { default: false })
  revoked: boolean;

  @Column('timestamptz', { nullable: true })
  revokedAt: Date | null;

  @Column('varchar', { length: 45, nullable: true }) // IP address
  issuedFrom: string | null;
}
```

### Token Rotation (Reveal Theft)
```typescript
// Every time a refresh token is used, issue a NEW refresh token
// and revoke the old one — prevents token theft reuse

async refreshTokens(refreshToken: string, ip: string) {
  // 1. Validate refresh token
  const payload = this.verifyRefreshToken(refreshToken);

  // 2. Check DB: not revoked, not expired
  const stored = await this.refreshTokenRepo.findOne({
    where: { id: payload.jti, revoked: false },
  });
  if (!stored || stored.expiresAt < new Date()) {
    throw new UnauthorizedException('Token revoked or expired');
  }

  // 3. Revoke old token (rotation)
  await this.refreshTokenRepo.update(stored.id, {
    revoked: true,
    revokedAt: new Date(),
  });

  // 4. Issue new tokens
  return this.issueTokens(user, ip);
}
```

## RBAC — Role & Permission System

```typescript
// Define roles
enum Role {
  SUPER_ADMIN = 'super_admin',
  ADMIN = 'admin',
  MANAGER = 'manager',
  USER = 'user',
  GUEST = 'guest',
}

// Define permissions
enum Permission {
  USER_READ = 'user:read',
  USER_WRITE = 'user:write',
  USER_DELETE = 'user:delete',
  ORDER_READ = 'order:read',
  ORDER_WRITE = 'order:write',
  BILLING_READ = 'billing:read',
}

// Role → Permissions mapping
const ROLE_PERMISSIONS: Record<Role, Permission[]> = {
  [Role.SUPER_ADMIN]: Object.values(Permission),
  [Role.ADMIN]: [Permission.USER_READ, Permission.USER_WRITE, Permission.ORDER_READ, Permission.ORDER_WRITE, Permission.BILLING_READ],
  [Role.MANAGER]: [Permission.USER_READ, Permission.ORDER_READ, Permission.ORDER_WRITE],
  [Role.USER]: [Permission.ORDER_READ, Permission.ORDER_WRITE],
  [Role.GUEST]: [Permission.ORDER_READ],
};

// Permission Guard
@Injectable()
export class PermissionGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const required = this.reflector.get<Permission[]>(PERMISSIONS_KEY, context.getHandler());
    if (!required) return true;

    const user = context.switchToHttp().getRequest().user;
    const userPermissions = ROLE_PERMISSIONS[user.role] ?? [];
    return required.every(p => userPermissions.includes(p));
  }
}

// Usage
@Get(':id')
@UseGuards(JwtAuthGuard, PermissionGuard)
@Permissions(Permission.ORDER_READ)
getOrder(@Param('id') id: string) { ... }
```

## Auth Attack Defenses

| Attack | Defense |
|---|---|
| Brute force login | Rate limiting + account lockout (5 attempts) |
| Credential stuffing | CAPTCHA after 3 failed attempts |
| Token theft | Refresh token rotation + revocation |
| Replay attack | Short-lived access tokens (15 min) |
| Password spray | Strong password policy + monitoring |
| Session fixation | Regenerate session ID after login |
| XSS token theft | HttpOnly, Secure cookies |

## Output Format

```
## Auth & AuthZ — [Context]

### Auth Flow
[ASCII diagram]

### JWT Payload
\`\`\`json
{ ... }
\`\`\`

### Token Rotation Logic
\`\`\`typescript
[code]
\`\`\`

### RBAC Matrix
| Role | Permissions |
|---|---|
| admin | [list] |
```

## Rules

- Use `bcrypt` (cost factor 12) or `argon2` — never MD5/SHA1
- Access token: max 15 minutes. Refresh token: max 7 days
- Always rotate refresh tokens on use (prevents token theft)
- Revoke ALL refresh tokens on password change
- Store tokens in HttpOnly cookies (not localStorage) in browsers
- Implement rate limiting on ALL auth endpoints
- Never log tokens or passwords — even in error messages