# Technical Solution Evaluator

## Description

Evaluate and recommend technical solutions for a given problem. Analyze feasibility, trade-offs, scalability, implementation time, and technical risks. Best for software engineers and architects choosing between technology options or designing systems.

## Triggered When

- User says "đánh giá giải pháp kỹ thuật này", "evaluate this technical approach"
- User says "nên dùng công nghệ gì cho X", "which tech stack for Y"
- User asks "có nên dùng A hay B", "A vs B — which is better"
- User says "giải pháp này có khả thi không", "is this solution feasible"
- User describes a technical problem and asks "cách tốt nhất để giải quyết là gì"
- User says "cần scale hệ thống, nên làm thế nào", "how to scale this"
- User asks about trade-offs between performance, complexity, maintainability
- User asks "rủi ro kỹ thuật của giải pháp này là gì", "what are technical risks here"
- User mentions "architecture decision", "ADR", or wants to compare options before deciding

## Analysis Framework

### 1. Problem Context
- **What is the problem:** System bottleneck, new feature, tech debt, compliance?
- **Scale requirements:** Current load, expected growth, peak concurrency
- **Constraints:** Time to implement, team expertise, existing infrastructure
- **Non-negotiables:** SLA, security, budget, regulatory requirements

### 2. Option Analysis (compare 2-4 options)

For each option, evaluate:

#### Feasibility
- Can we build this with current stack and team skills?
- What's missing (new skills, tools, services)?
- Build vs buy vs open-source tradeoff?

#### Trade-off Matrix
| Dimension | Option A | Option B | Option C |
|---|---|---|---|
| Performance | | | |
| Complexity | | | |
| Maintainability | | | |
| Time to implement | | | |
| Operational overhead | | | |
| Cost | | | |

#### Scalability
- Horizontal vs vertical scaling?
- Can it handle 10x, 100x current load?
- What's the bottleneck at scale?
- Cost curve as usage grows?

#### Implementation Estimate
```
Time = Research + Build + Test + Integrate + Document + Buffer

Research:  How much exploration/learning needed?
Build:     How long to write production-ready code?
Test:      How much testing coverage needed?
Integrate: How much work to wire into existing system?
Buffer:    20-30% for unknowns and edge cases
```

### 3. Technical Risk Assessment
| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Dependency failure | Low/Med/High | Low/Med/High | Fallback strategy |
| Vendor lock-in | Low/Med/High | Low/Med/High | Escape hatch plan |
| Security vulnerability | Low/Med/High | Low/Med/High | Security measures |
| Performance at scale | Low/Med/High | Low/Med/High | Load testing plan |
| Team skill gap | Low/Med/High | Low/Med/High | Training or hire plan |

### 4. Recommendation Logic
Use the following decision tree:
```
Can we build it?
├── Yes → Is it the best option?
│         ├── Yes → Recommend + document trade-offs
│         └── No  → Recommend better option + explain why
└── No → Is there a simpler alternative?
          ├── Yes → Recommend alternative + note capability gap
          └── No  → Flag as blocker, suggest path to enable
```

## Output Format

```
## ⚙️ Technical Solution Evaluator — [Problem / Context]

### 📌 Problem Statement
- **Problem:** [What needs to be solved]
- **Context:** [Why this matters now, current situation]
- **Constraints:** [Time, budget, team, SLA, security]

### 🏗️ Options Evaluated

#### Option A: [Name]
**Description:** [How it works]
**Pros:**
- ...
**Cons:**
- ...
**Feasibility:** [High / Medium / Low] — [Why]
**Time to implement:** [X days/weeks]

#### Option B: [Name]
**Description:** [How it works]
**Pros:**
- ...
**Cons:**
- ...
**Feasibility:** [High / Medium / Low] — [Why]
**Time to implement:** [X days/weeks]

#### Option C: [Name] (if applicable)
...

### 📊 Comparison Matrix
| Dimension | Option A | Option B | Option C |
|---|---|---|---|
| Performance | | | |
| Complexity | | | |
| Maintainability | | | |
| Time to implement | | | |
| Scalability | | | |
| Operational overhead | | | |
| Cost | | | |

### ⚠️ Risk Assessment
| Risk | Option A | Option B | Option C |
|---|---|---|---|
| Dependency failure | | | |
| Vendor lock-in | | | |
| Security | | | |
| Scale bottleneck | | | |
| Team skill gap | | | |

### ✅ Recommendation

**Selected:** [Option name]
**Confidence:** [High / Medium / Low] — [Reason]

**Rationale:** [2-3 sentences on why this is the best choice]

**Trade-offs accepted:**
- [What you're giving up by choosing this option]
- [Why those trade-offs are acceptable]

**Next steps:**
1. [Immediate action]
2. [Follow-up action]

**Monitoring plan:**
- [What metrics to track]
- [What alert thresholds to set]
```

## Rules

- Always evaluate at least 2 options when possible (except when problem is trivial)
- Be explicit about trade-offs — every choice has a cost
- Consider team expertise — the "best" tech that's outside team capability is often the wrong choice
- Flag vendor lock-in risks for managed/cloud services
- Note cost implications at different scales (especially for cloud services)
- For Vietnamese tech context: note local provider options (Viettel, VNPT cloud vs AWS/GCP)
- Recommend "MVP first" approach when appropriate — build simple, prove value, then optimize
- Don't over-engineer: if the problem is small, the solution should be small too