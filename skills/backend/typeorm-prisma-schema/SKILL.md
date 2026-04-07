# TypeORM / Prisma Schema

## Description

Generates TypeScript entity definitions for TypeORM or schema definitions for Prisma. Covers relations, migrations, indices, and data type mapping. Produces production-ready schemas with proper constraints, timestamps, and soft delete support.

## Triggered When

- User says "create entity", "define model", "TypeORM entity", "Prisma schema"
- User says "tạo entity", "định nghĩa model", "schema TypeORM", "Prisma schema"
- User asks about "relations", "migrations", "indexes", "soft delete"
- User says "quan hệ bảng", "migration", "soft delete", "index"
- Designing a data model for a new feature
- User says "typeorm relation", "prisma relation", "join table"

## TypeORM Entity Template

```typescript
// entities/user.entity.ts
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  Index,
  OneToMany,
} from 'typeorm';
import { Order } from './order.entity';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 255, unique: true })
  @Index('uniq_users_email')
  email: string;

  @Column({ type: 'varchar', length: 255 })
  name: string;

  @Column({ type: 'varchar', length: 255, select: false })
  passwordHash: string;

  @Column({ type: 'enum', enum: UserRole, default: UserRole.USER })
  @Index('idx_users_role')
  role: UserRole;

  @Column({ type: 'boolean', default: true })
  isActive: boolean;

  @CreateDateColumn({ type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ type: 'timestamptz' })
  updatedAt: Date;

  @DeleteDateColumn({ type: 'timestamptz', nullable: true })
  deletedAt: Date | null;

  // Relations
  @OneToMany(() => Order, (order) => order.user)
  orders: Order[];
}
```

## Prisma Schema Template

```prisma
// prisma/schema.prisma

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id           String    @id @default(uuid())
  email        String    @unique
  name         String
  passwordHash String
  role          UserRole @default(USER)
  isActive     Boolean   @default(true)

  createdAt   DateTime  @default(now())
  updatedAt   DateTime  @updatedAt
  deletedAt   DateTime?

  orders       Order[]
  sessions     Session[]

  @@index([role])
  @@map("users")
}

model Order {
  id      String   @id @default(uuid())
  userId  String
  status  OrderStatus @default(PENDING)
  total   Decimal  @db.Decimal(19, 4)

  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  user  User   @relation(fields: [userId], references: [id])
  items OrderItem[]

  @@index([userId])
  @@index([status])
  @@map("orders")
}

enum UserRole {
  USER
  ADMIN
}

enum OrderStatus {
  PENDING
  PAID
  SHIPPED
  CANCELLED
}
```

## Relation Types

### TypeORM
```typescript
// One-to-Many
@OneToMany(() => Order, (order) => order.user)
orders: Order[];

// Many-to-One (on the other side)
@ManyToOne(() => User, (user) => user.orders)
@JoinColumn({ name: 'user_id' })
user: User;

// Many-to-Many (join table)
@ManyToMany(() => Tag, (tag) => tag.posts)
@JoinTable({
  name: 'post_tags',
  joinColumn: { name: 'post_id' },
  inverseJoinColumn: { name: 'tag_id' },
})
tags: Tag[];

// One-to-One
@OneToOne(() => Profile, (profile) => profile.user)
@JoinColumn()
profile: Profile;
```

### Prisma
```prisma
// One-to-Many
user   User   @relation(fields: [userId], references: [id])

// Many-to-Many (auto-generated join table)
posts    Post[]
tags     Tag[]   @relation()

// One-to-One
profile  Profile?
```

## Migration Commands

### TypeORM
```bash
# Generate migration from entity changes
npx typeorm migration:generate -d src/database/data-source.ts AddUserTable

# Run pending migrations
npx typeorm migration:run -d src/database/data-source.ts

# Revert last migration
npx typeorm migration:revert -d src/database/data-source.ts

# Create empty migration
npx typeorm migration:create AddRoleColumn
```

### Prisma
```bash
# Generate client after schema change
npx prisma generate

# Create migration
npx prisma migrate dev --name add_user_table

# Apply to production
npx prisma migrate deploy

# Reset (dev only — DANGEROUS)
npx prisma migrate reset
```

## Soft Delete Patterns

### TypeORM (with TypeORM Typed-config)
```typescript
// Soft delete query runner
async findActive(id: string) {
  return this.repo.findOne({
    where: { id },
    withDeleted: true, // include soft-deleted
  });
}

async softDelete(id: string) {
  return this.repo.softDelete(id); // sets deletedAt
}
```

### Prisma
```prisma
model User {
  deletedAt DateTime?
}

query.findMany({
  where: { deletedAt: null }
})
```

## Checklist

- [ ] All entities defined with UUID primary keys
- [ ] Foreign keys indexed
- [ ] Unique constraints for natural keys (email, etc.)
- [ ] Timestamps: createdAt, updatedAt (every table)
- [ ] Soft delete: deletedAt (if needed)
- [ ] Enum types defined for status/role fields
- [ ] Decimal for money/currency (not float)
- [ ] Migration generated and tested

## Output Format

```
## Schema — [Module/Entity]

### TypeORM Entity
\`\`\`typescript
[entity code]
\`\`\`

### Prisma Schema
\`\`\`prisma
[schema code]
\`\`\`

### Migration
\`\`\`sql
[SQL migration]
\`\`\`
```

## Rules

- Use `uuid` for all primary keys (not auto-increment integers)
- Use `decimal(19,4)` for all monetary fields — never float/double
- Always add `createdAt` and `updatedAt` timestamps
- Index every foreign key column
- Use `cascade` with care — prefer explicit orphan removal
- Use Prisma for new projects; TypeORM for existing large codebases