# Database Schema

## Description

Designs database schemas that are normalized, performant, and maintainable. Covers entity definition, relationships, indexing strategy, migration plans, and data type selection for PostgreSQL (primary), MySQL, and SQLite.

## Triggered When

- User says "design a database schema", "create a table"
- User says "thiết kế database", "tạo bảng", "schema này thế nào"
- User asks about "relationships", "foreign keys", "indexes", "quan hệ bảng"
- User asks "should I normalize this", "what indexes to add", "có cần index không"
- Planning a new feature that needs a data model
- User says "migration", "add column", "schema change", "thêm cột"

## Normalization Levels

| Level | Description | When to use |
|---|---|---|
| 3NF | No transitive dependencies | Most features — default target |
| 2NF | No partial dependencies on composite keys | Only if composite PK exists |
| 1NF | Atomic values, no repeating groups | Minimum standard |

**Denormalize ONLY when:**
- Read performance is critical and proven
- You have a specific measurement, not a guess
- The trade-off is understood and documented

## Naming Convention

### Table & Column Names
- **Tables**: plural, snake_case — `users`, `order_items`
- **Columns**: snake_case — `created_at`, `user_id`
- **PK**: `{table_singular}_id` or `id` — `user_id` or `id`
- **FK**: `{related_table_singular}_id` — `order_id`, `product_id`
- **Indexes**: `idx_{table}_{columns}` — `idx_orders_user_id`
- **Uniques**: `uniq_{table}_{columns}` — `uniq_users_email`

### Common Column Types

| Data | PostgreSQL | MySQL | Notes |
|---|---|---|---|
| UUID primary key | `uuid` PK | `char(36)` | Auto-generate with `gen_random_uuid()` |
| Auto-increment PK | `serial` | `int auto_increment` | Use UUID unless specific reason |
| Timestamps | `timestamptz` | `datetime` | Always UTC |
| Boolean | `boolean` | `tinyint(1)` | Prefer boolean |
| Enum | `enum` or text + check | `enum` | Prefer text + check constraint |
| JSON | `jsonb` | `json` | jsonb for Postgres (indexable) |
| Currency | `numeric(19,4)` | `decimal(19,4)` | Never use float/double |
| Email | `varchar(255)` | `varchar(255)` | With unique constraint |
| Password hash | `varchar(255)` | `varchar(255)` | bcrypt output is 60 chars |

## Indexing Strategy

### Must Index (always)
- Primary key (automatic)
- Foreign keys
- Columns used in `WHERE` conditions frequently
- `UNIQUE` constraints

### Consider Indexing
- Columns in `ORDER BY` with high cardinality
- Columns in `GROUP BY`
- Composite indexes for multi-column queries

### Avoid Indexing
- Low-cardinality columns (`is_active`, `status`)
- Columns rarely queried
- Columns only in `SELECT` but not `WHERE`

### Composite Index Order
```
Index (A, B, C) — use for:
✅ WHERE A = ? AND B = ? AND C = ?
✅ WHERE A = ? AND B = ?
✅ WHERE A = ?

❌ WHERE B = ?        — NOT used
❌ WHERE C = ?        — NOT used
```

## Schema Design Checklist

- [ ] All entities identified with clear purpose
- [ ] Primary keys defined (prefer UUID)
- [ ] Foreign key relationships documented
- [ ] Soft delete strategy considered (deleted_at vs is_active)
- [ ] Timestamps consistent (created_at, updated_at)
- [ ] Indexes for all foreign keys
- [ ] Indexes for frequent WHERE columns
- [ ] Unique constraints for natural keys (email, etc.)
- [ ] Data type appropriate for the data
- [ ] Currency fields use decimal, not float

## Migration Template

```sql
-- Migration: [title]
-- Created: YYYY-MM-DD

BEGIN;

-- Create table
CREATE TABLE IF NOT EXISTS {table_name} (
    id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    {col}       {type}      {constraints},
    created_at  timestamptz NOT NULL DEFAULT now(),
    updated_at  timestamptz NOT NULL DEFAULT now()
);

-- Indexes
CREATE INDEX idx_{table}_{col} ON {table}({col});

-- Comments
COMMENT ON TABLE {table} IS '...';
COMMENT ON COLUMN {table}.{col} IS '...';

COMMIT;
```

## Output Format

```
## Database Schema — [Feature/Module]

### ERD Overview
[text-based entity relationship]

### Tables

#### users
| Column | Type | Constraints | Index | Notes |
|---|---|---|---|---|
| id | uuid | PK | PK | |
| email | varchar(255) | UNIQUE, NOT NULL | ✅ uniq | |
| created_at | timestamptz | NOT NULL | | |

#### orders
| Column | Type | Constraints | Index | Notes |
|---|---|---|---|---|
| id | uuid | PK | PK | |
| user_id | uuid | FK → users(id) | ✅ idx | |

### Relationships
- users 1:N orders
- orders 1:N order_items

### Migration SQL
\`\`\`sql
[full migration]
\`\`\`
```

## Rules

- Always use UUID for public-facing IDs (never expose sequential int)
- Every table needs `created_at`; most need `updated_at`
- Foreign keys must have indexes
- Write migrations as up/down pairs when possible
- Test migrations against production-size data volumes
