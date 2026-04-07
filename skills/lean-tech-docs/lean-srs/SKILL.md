# Lean SRS (Software Requirements Specification)

## Description

Expert in writing lean, practical Software Requirements Specifications for freelance projects and client work. Produces "just enough" documentation — clear enough to build from, not so heavy it becomes stale before the first line of code.

## Triggered When

- User says "write SRS", "document requirements", "scope this project"
- User says "viết SRS", "tài liệu yêu cầu", "định nghĩa phạm vi dự án"
- User is scoping a freelance project or client engagement
- User says "requirement doc", "tài liệu spec", "scope dự án", "yêu cầu khách hàng"
- User asks "what should be in a requirements doc" or "how detailed should specs be"
- User wants to avoid ambiguity before development starts

## Lean SRS Principles

1. **Write for your audience**: client reads intro + scope + non-functional; developer reads features + acceptance criteria
2. **Spec the "what", not the "how"**: describe behavior, not implementation
3. **Just enough detail**: if it takes > 2 sentences to describe a feature, it's too complex — break it down
4. **Living doc**: treat it as a starting point, update when scope changes (log changes in appendix)
5. **Acceptance criteria = contract**: if it can't be tested, it's not a requirement

## SRS Template (3-5 pages max)

```markdown
# [Project Name] — Software Requirements Specification

**Version:** 1.0
**Date:** [date]
**Status:** Draft / Approved
**Author:** [name]

---

## 1. Overview (½ page)

### 1.1 Purpose
What this project does and who it's for in one paragraph.

### 1.2 Scope
What's included (and explicitly excluded — "The system will NOT handle...").

### 1.3 Success Criteria
3-5 measurable outcomes:
- [ ] Metric or outcome 1
- [ ] Metric or outcome 2

---

## 2. User Stories & Features

### 2.1 User Roles
| Role | Description | Count (if known) |
|---|---|---|
| User | ... | ... |
| Admin | ... | ... |

### 2.2 User Stories (optional — use if simpler than feature list)
- **As a** [role], **I want** [feature] **so that** [benefit]
  - **Acceptance criteria:**
    - Given [context] when [action] then [result]

### 2.3 Features (use if clearer than user stories)
For each feature:
```
Feature: [Name]
Priority: Must / Should / Could
Description: 1-2 sentences
Acceptance criteria:
- [ ] [Criterion 1]
- [ ] [Criterion 2]
Notes: [edge cases or clarifications, if any]
```

---

## 3. Data & Integrations

### 3.1 Data Model (lightweight)
- Entity: [name] — fields: [list], owned by: [role]
- (Entity Relationship diagram optional — use if complex)

### 3.2 External Integrations
| Integration | Purpose | Data shared |
|---|---|---|
| Stripe | Payments | Amount, status, customer |
| SendGrid | Email | Template vars |

---

## 4. Non-Functional Requirements

| Requirement | Target |
|---|---|
| Performance | Page load < 2s on 3G |
| Availability | 99% uptime |
| Security | OWASP Top 10 compliant |
| Browser support | Last 2 Chrome/Firefox/Safari |
| Mobile | Responsive (not native app) |
| Data retention | [X] days, then deleted |

---

## 5. Out of Scope (explicit)

- Feature or requirement that might be asked for later
- Be honest about what's NOT included to avoid scope creep

---

## 6. Timeline & Milestones

| Milestone | Deliverable | Target Date |
|---|---|---|
| M1 | Design approved | ... |
| M2 | Core features | ... |
| M3 | Testing & QA | ... |
| M4 | Launch | ... |

---

## Appendix: Change Log
| Date | Change | Approved by |
|---|---|---|
| ... | ... | ... |
```

## Output Format

When generating an SRS, produce:
1. Overview section (purpose, scope, success criteria)
2. Features with acceptance criteria
3. Lightweight data model (entity list, not full ERD)
4. Non-functional requirements table
5. Explicit out-of-scope list
6. Timeline with milestones

## Rules

- Keep under 5 pages — if it's longer, split into Phase 1 / Phase 2
- Every "Must" feature must have at least one acceptance criterion
- Get client sign-off (email confirmation counts) before starting build
- Update the change log when scope changes — never silently change the spec
