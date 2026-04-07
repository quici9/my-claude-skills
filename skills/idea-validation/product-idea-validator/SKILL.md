# Product Idea Validator

## Description

Evaluate whether a product idea or startup concept is viable. Analyze problem-solution fit, market opportunity, MVP scope, and risks before committing resources. Best for founders, product managers, or anyone with a new product concept.

## Triggered When

- User says "đánh giá ý tưởng sản phẩm này", "evaluate this product idea", "nên làm sản phẩm này không"
- User shares a startup idea and asks "có khả thi không", "is this viable"
- User says "có nên theo đuổi ý tưởng này không", "worth pursuing"
- User asks "what's the market for X?", "thị trường của sản phẩm này thế nào"
- User says "MVP của sản phẩm này cần gì", "what should I build first"
- User asks about competitor landscape or differentiation
- User says "rủi ro của sản phẩm này là gì", "what are the risks of this idea"
- User says "validate ý tưởng này giúp tôi", "help me validate this idea"

## Analysis Framework

### 1. Problem-Solution Fit
- **Problem validation:** Is the problem real and painful enough that people will pay to solve it?
  - Is this a "nice to have" or a "must have"?
  - How do people currently solve this problem?
  - What is the cost of not solving it?
- **Solution fit:** Does the proposed solution actually address the root cause?
  - Is the solution approach aligned with how users think/work?
  - Is the solution 10x better than alternatives or just 10% better?
- **ICP (Ideal Customer Profile):** Who is the primary user? Can you describe them in one sentence?
  - Demographics, role, company size, behaviors
  - Do they have the budget and authority to buy?
  - Are they actively searching for a solution?

### 2. Market Opportunity
- **Market size:** TAM / SAM / SOM — be realistic, not optimistic
- **Market timing:** Why now? What changed (technology, regulation, behavior shift)?
- **Competition:** Who else solves this problem?
  - Direct competitors: same solution, same ICP
  - Indirect competitors: alternative solutions, same ICP
  - Substitute: people live with the problem instead
- **Differentiation:** What makes your approach defensible?
  - Network effects, data moat, brand, pricing, distribution?

### 3. MVP Scope
- **Must-have features:** The 1-3 things that make the core value proposition work
- **Nice-to-have:** Can be added later without changing core value
- **What to NOT build:** Explicitly state what is out of scope
- **Validation strategy:** How will you know if people want this?
  - Landing page signups, smoke test, concierge, prototype pre-orders

### 4. Business Model
- **Revenue model:** Subscription / one-time / marketplace / ads / etc.
- **Unit economics:** CAC, LTV, margin — even rough numbers
- **Pricing:** What will you charge? Why will people pay that?
- **Go-to-market:** How will you acquire first 10 customers?

### 5. Risk Assessment
| Risk Type | Low | Medium | High |
|---|---|---|---|
| Technical | Simple build, well-understood tech | Some new tech, some unknowns | Novel, unproven, complex |
| Market | Large underserved market | Moderate demand, existing competitors | Small market, crowded, declining |
| Competition | Clear differentiation | Some differentiation, room for niche | Commoditized, incumbents dominate |
| Execution | Clear path to MVP | Some ambiguity, need to validate | Unclear what to build, ICP not defined |
| Regulatory | No regulatory concerns | Some regulatory questions | Heavy regulation, legal uncertainty |

### 6. Decision Framework
```
Pursue  → Problem is real, market exists, differentiation clear, MVP scoped
Pivot   → Core problem valid but solution/market/ICP needs rethinking
Park    → Problem too small, competition too strong, or timing wrong
```

## Output Format

```
## 🔬 Product Idea Validator — [Product Name]

### 🎯 Problem-Solution Fit
**Problem:** [1-2 sentence description of the problem]
**Pain level:** [Critical / High / Medium / Low]
**Current alternatives:** [What people do today]
**Solution fit:** [How your solution addresses the root cause]

**ICP:** [1-sentence description of ideal customer]
**Budget holder:** [Do they pay? How much?]

### 🌐 Market Analysis
- **TAM:** [Estimated market size]
- **SAM:** [Serviceable addressable market]
- **SOM:** [First-year realistic target]

**Timing:** [Why now?] — [What changed?]

**Competition:**
| Competitor | What they do | Your advantage |
|---|---|---|
| [Name] | [Description] | [Differentiation] |
| [Name] | [Description] | [Differentiation] |

### 🚀 MVP Scope
**Core value:** [1-sentence — what is the one thing this product must deliver?]

Must-have (MVP):
1. [Feature]
2. [Feature]
3. [Feature]

Nice-to-have (Post-MVP):
- [Feature]
- [Feature]

**Out of scope:**
- [Feature]

**Validation path:** [How to test demand before building]

### 💵 Business Model
- **Revenue model:** [Subscription / etc.]
- **Target price:** [X VND/month or $X/month]
- **Unit economics:** [Rough CAC / LTV / margin if known]
- **First 10 customers:** [How to acquire]

### ⚠️ Risk Assessment
| Risk | Level | Mitigation |
|---|---|---|
| Technical | [L/M/H] | [How to reduce] |
| Market | [L/M/H] | [How to reduce] |
| Competition | [L/M/H] | [How to reduce] |
| Execution | [L/M/H] | [How to reduce] |
| Regulatory | [L/M/H] | [How to reduce] |

### 📋 Decision
| Option | Criteria |
|---|---|
| **🎯 Pursue** | Real problem, clear market, differentiated approach |
| **🔄 Pivot** | Problem valid but needs different solution/market/ICP |
| **🅿️ Park** | Too small, too crowded, or wrong timing |

**Verdict:** [Pursue / Pivot / Park]
**Rationale:** [2-3 sentence explanation]
**Next step:** [The most important 1-2 actions to validate or kill this idea]
```

## Rules

- Challenge assumptions — don't just validate what the user wants to hear
- Distinguish between "interesting" and "viable" — push back on vague ideas
- Flag if the "problem" is actually a "solution looking for a problem"
- Be specific about MVP scope — most ideas are scoped too large
- Ask for data or evidence if claims are not backed up
- For Vietnamese market: note local context (payment behavior, competition, regulation)