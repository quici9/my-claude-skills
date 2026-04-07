# ADR + SDD Lite

## Description

Expert in writing lightweight Architecture Decision Records (ADRs) and Software Design Documents (SDDs). Captures the "why" behind technical decisions — just enough detail to inform future engineers, without the overhead of heavyweight design documents.

## Triggered When

- User says "write an ADR", "document this decision", "record this choice"
- User says "viết ADR", "ghi lại quyết định kiến trúc", "tài liệu thiết kế"
- User asks "why was this designed this way?" or "what are the alternatives we considered?"
- User says "sao chọn cách này", "có phương án nào khác không", "thiết kế này tại sao"
- User asks about architecture, design choices, or trade-offs for a feature
- User wants a lightweight design doc before implementing a complex feature

## When to Write an ADR vs an SDD

| Situation | Use |
|---|---|
| Single significant decision | **ADR** (1-2 pages) |
| Multi-service, cross-team, or risky change | **SDD** (3-5 pages) |
| Routine implementation choice | Comment in code (no doc needed) |
| Reversible, low-risk decision | Slack message + "we'll ADR it later if it matters" |

**Golden rule**: If you'll need to remember this decision in 6 months, write it down. If not, skip it.

---

## ADR (Architecture Decision Record)

### Format ( lightweight — 1 page )

```markdown
# ADR-[N]: [Decision title]

**Date:** YYYY-MM-DD
**Status:** Proposed / Accepted / Deprecated / Superseded by ADR-[X]
**Context:** [What situation prompted this decision?]
**Decision:** [What was decided?]
**Consequences:**
  - **Positive:** [Benefits]
  - **Negative:** [Drawbacks / trade-offs]
  - **Neutral:** [Things that will change but aren't good or bad]
**Alternatives Considered:**
  - **[Option A]**: [Pros / cons vs decision]
  - **[Option B]**: [Pros / cons vs decision]
**Supersedes:** ADR-[X] (if applicable)
**Superseded by:** ADR-[Y] (if applicable)
```

### ADR Examples

**Good ADR topics:**
- "Use PostgreSQL instead of MongoDB for user data"
- "Adopt JWT with refresh token rotation for auth"
- "Split monolith into user-service and order-service"
- "Use Redis for session storage instead of DB-backed sessions"
- "Adopt OpenTelemetry for distributed tracing"

**Skip ADR (too trivial):**
- "Use camelCase for variable names" → put in style guide
- "Add unit tests for service X" → not an architectural decision

### ADR Index

Maintain a single `docs/adr/INDEX.md`:

```markdown
# ADR Index

| ID | Title | Status | Date |
|---|---|---|---|
| ADR-001 | Use PostgreSQL for user data | Accepted | 2026-01-15 |
| ADR-002 | Adopt JWT + refresh token | Accepted | 2026-02-01 |
| ADR-003 | Decompose into microservices | Deprecated | 2026-03-10 |

<!-- Use ADR-000, ADR-001, ... sequentially -->
```

---

## SDD Lite (Software Design Document)

Use when: multi-team impact, new service, significant refactor, or high uncertainty.

### Format (3-5 pages max)

```markdown
# SDD-[N]: [Title]

**Author:** [name]
**Date:** YYYY-MM-DD
**Status:** Draft / Review / Approved
**Stakeholders:** [team/people who need to review]

---

## 1. Summary
1-3 sentences: what are we building/changing, and why?

## 2. Background
Context: what led to this? Any constraints? Related ADRs?

## 3. Proposed Design

### 3.1 High-Level Architecture
ASCII diagram or description of components and their interactions.

### 3.2 Data Model
Lightweight: entity name, key fields, relationships. No full ERD unless essential.

### 3.3 API Contracts
If new endpoints, summarize: method, path, purpose, auth required.

### 3.4 Security Considerations
Auth, data isolation, any sensitive data handling.

### 3.5 Deployment / Migration
How does this get to production? Any migration steps? Rollback plan?

## 4. Alternatives Considered
Why not the other options? (reference ADRs if decisions already recorded)

## 5. Open Questions
Known unknowns: what do we need to decide before implementing?
- [ ] [Question 1]
- [ ] [Question 2]

## 6. Risks
| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| ... | High/Med/Low | High/Med/Low | ... |

## 7. Acceptance Criteria
- [ ] [Criterion 1 — testable]
- [ ] [Criterion 2 — testable]

## 8. Review & Sign-off
| Name | Role | Date | Signature |
|---|---|---|---|
| ... | ... | ... | ... |
```

## Output Format

### For ADR:
```
## ADR-[N]: [Title]

Status: Accepted
Date: YYYY-MM-DD

**Context:** ...
**Decision:** ...
**Consequences:**
  - ✅ Positive: ...
  - ⚠️ Negative: ...
**Alternatives:** ...
```

### For SDD:
```
## SDD-[N]: [Title]

**Status:** Draft

### Architecture
[ASCII diagram]

### Data Model
[Entities]

### Open Questions
- [ ] ...

### Risks
| Risk | L | I | Mitigation |
|---|---|---|---|
| ... | H | H | ... |

### Reviewers
- [ ]
```

## Rules

- **ADRs**: keep to 1 page, future you will thank present you
- **Status** must be updated when a decision changes (never leave "Proposed" forever)
- **Link related ADRs**: e.g., "Supersedes ADR-004"
- **SDD before implementation**: not after — if writing SDD post-hoc, you're doing archaeology
- **Reviewers required**: SDD needs at least one peer review before implementation
- **ADRs are immutable history**: never delete or rewrite old ADRs, just mark deprecated
