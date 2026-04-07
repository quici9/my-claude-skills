# NestJS DTO & Validation

## Description

Generates robust TypeScript DTOs with `class-validator` decorators in whitelist mode, OpenAPI/Swagger decorators, and proper type transformation. Ensures every incoming request is fully validated before reaching business logic.

## Triggered When

- User says "create DTO", "add validation", "validate input"
- User says "tạo DTO", "thêm validation", "kiểm tra input"
- User asks "what validator should I use", "IsOptional vs IsOptional()", "nên dùng decorator nào"
- Designing create/update DTOs for a new endpoint
- User says "request body validation", "request body type", "validate body"

## DTO Structure

```
dto/
├── create-{resource}.dto.ts    ← All required fields
├── update-{resource}.dto.ts    ← All optional fields
├── {resource}-query.dto.ts     ← Query params with defaults
└── {resource}-params.dto.ts    ← Route params with validation
```

## Core Validators Reference

| Decorator | Use for | Example |
|---|---|---|
| `@IsString()` | String fields | name: string |
| `@IsNumber()` | Numeric fields | age: number |
| `@IsBoolean()` | Boolean fields | isActive: boolean |
| `@IsEmail()` | Email addresses | email: string |
| `@IsUrl()` | URL fields | website: string |
| `@IsInt()` | Integer only | page: number |
| `@IsPositive()` | Positive numbers | price: number |
| `@IsDateString()` | ISO date strings | startDate: string |
| `@IsEnum()` | Enum values | status: UserStatus |
| `@IsUUID()` | UUID strings | id: string |
| `@IsArray()` | Arrays | tags: string[] |
| `@IsObject()` | Objects | metadata: object |
| `@IsIn()` | Whitelist of values | role: 'admin' \| 'user' |
| `@IsPhoneNumber()` | Phone (requires class-validator >= 0.14) | phone: string |
| `@MinLength(n)` | Minimum string length | passwordMin: string |
| `@MaxLength(n)` | Maximum string length | bio: string |
| `@Min(n)` | Minimum number | minPrice: number |
| `@Max(n)` | Maximum number | maxPrice: number |
| `@Matches(regex)` | Regex pattern | zipCode: string |
| `@IsOptional()` | Field may be absent | nickname?: string |
| `@ValidateNested()` | Nested object validation | @ValidateNested() @Type(() => AddressDto) |
| `@ArrayMinSize(n)` | Min array length | items: string[] |
| `@ArrayMaxSize(n)` | Max array length | items: string[] |

## Whitelist Mode (Required — Security)

```typescript
// main.ts
app.useGlobalPipes(
  new ValidationPipe({
    whitelist: true,          // Strip non-decorated fields
    forbidNonWhitelisted: true, // Throw if non-whitelisted fields present
    transform: true,            // Auto-transform query/body to DTO types
    transformOptions: {
      enableImplicitConversion: true, // Auto-convert types (string → number)
    },
  }),
);
```

## DTO Templates

### Create DTO (all required)
```typescript
// create-user.dto.ts
import {
  IsString,
  IsEmail,
  IsEnum,
  IsOptional,
  MinLength,
  MaxLength,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { UserRole } from '../../enums/user-role.enum';

export class CreateUserDto {
  @ApiProperty({ example: 'john@example.com' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: 'John Doe' })
  @IsString()
  @MinLength(2)
  @MaxLength(100)
  name: string;

  @ApiProperty({ example: 'securePass123' })
  @IsString()
  @MinLength(8)
  @MaxLength(128)
  password: string;

  @ApiPropertyOptional({ enum: UserRole, default: UserRole.USER })
  @IsEnum(UserRole)
  @IsOptional()
  role?: UserRole;
}
```

### Update DTO (all optional)
```typescript
// update-user.dto.ts
import { PartialType } from '@nestjs/swagger';
import { CreateUserDto } from './create-user.dto';

// PartialType makes all fields optional + inherits Swagger metadata
export class UpdateUserDto extends PartialType(CreateUserDto) {}
```

### Query DTO
```typescript
// users-query.dto.ts
import { IsOptional, IsInt, IsString, IsEnum, Min, Max } from 'class-validator';
import { Type } from 'class-transformer';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { UserRole } from '../../enums/user-role.enum';

export class UsersQueryDto {
  @ApiPropertyOptional({ default: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page?: number = 1;

  @ApiPropertyOptional({ default: 20 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number = 20;

  @ApiPropertyOptional({ enum: UserRole })
  @IsOptional()
  @IsEnum(UserRole)
  role?: UserRole;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  search?: string;
}
```

### Params DTO
```typescript
// user-params.dto.ts
import { IsUUID } from 'class-validator';
import { ApiParam } from '@nestjs/swagger';
import { ParamUUIDDto } from '../../../common/dto/param-uuid.dto';

// Extend common ParamUUIDDto or define inline
export class UserParamsDto extends ParamUUIDDto {}
```

## NestJS Pipe Setup (Global)

```typescript
// main.ts
import { ValidationPipe } from '@nestjs/common';

app.useGlobalPipes(
  new ValidationPipe({
    // ✅ REQUIRED — Security
    whitelist: true,
    forbidNonWhitelisted: true,

    // ✅ Auto-transform query params to correct types
    transform: true,
    transformOptions: {
      enableImplicitConversion: true,
    },

    // Disable if you want explicit @Type() on every field
    // enableImplicitConversion: false,
  }),
);
```

## Swagger Metadata Guide

```typescript
@ApiProperty()           // Required field
@ApiPropertyOptional()  // Optional field
@ApiProperty({ enum: ... })  // Enum field
@ApiProperty({ example: '...' })  // With example
@ApiProperty({ description: '...' })  // With description
@ApiHideProperty()       // Hide from docs
```

## Output Format

```
## DTO — [Resource Name]

### create-{resource}.dto.ts
\`\`\`typescript
[full DTO code]
\`\`\`

### update-{resource}.dto.ts
\`\`\`typescript
[full DTO code]
\`\`\`

### {resource}-query.dto.ts
\`\`\`typescript
[full DTO code]
\`\`\`

### Validation Notes
- whitelist: ✅ enabled
- forbidNonWhitelisted: ✅ enabled
- transform: ✅ enabled
```

## Rules

- **Always use `whitelist: true`** — non-decorated fields are stripped
- Use `@ApiProperty()` for every field (Swagger documentation)
- Use `PartialType()` from `@nestjs/swagger` for Update DTOs (not `@nestjs/mapped-types`)
- Use `@ValidateNested()` + `@Type()` for nested objects
- Never use `any` in DTOs — define explicit types
- Group enums in a separate `enums/` directory
