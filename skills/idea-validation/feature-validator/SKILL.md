# Feature Validator

## Description

Evaluate whether a feature idea is worth building. Analyze user value, development effort, and priority using a structured framework. Best for software product teams validating feature requests before committing engineering time.

## Triggered When

- User says "đánh giá feature này", "evaluate this feature", "nên build feature này không"
- User shares a feature idea and asks "có đáng để build không", "worth building?"
- User says "feature này ưu tiên thế nào", "priority của feature này"
- User asks "what's the ROI of this feature?", "lợi ích feature này là gì"
- User says "cần bao lâu để build feature X", "how long to build this"
- User mentions a feature request and wants to know if they should pursue it

## Analysis Framework

### 1. User Value Assessment
- **Pain point:** What problem does this solve? How painful is it for users?
- **Target users:** Who benefits? How many users?
- **Frequency:** How often will users use this? (one-time, daily, weekly)
- **Impact severity:** Critical blocker / major annoyance / minor convenience
- **Alternatives:** What do users do today if this doesn't exist?

### 2. Development Effort
- **Time estimate:** XS (<1 day) / S (1-3 days) / M (3-7 days) / L (1-2 weeks) / XL (2-4 weeks) / XXL (>1 month)
- **Complexity:** Low (existing patterns) / Medium (new patterns, needs design) / High (novel, risky)
- **Dependencies:** Any external services, APIs, or team handoffs needed?
- **Tech debt:** Does this require refactoring existing code?
- **Testing effort:** How much QA/testing is needed?

### 3. RICE Scoring (if enough info)
```
RICE Score = (Reach × Impact × Confidence) / Effort

Reach:     Estimated users impacted per quarter (1-1000+)
Impact:    3=massive, 2=high, 1=medium, 0.5=low, 0.25=minimal
Confidence: 100%=high certainty, 80%=some research, 50%=gut feeling
Effort:    Person-weeks (0.5=half, 1=one, 2=two weeks, etc.)
```

### 4. Strategic Fit
- **Alignment:** Does this align with product roadmap or OKRs?
- **Enabler:** Does this unlock other features or revenue?
- **Competitive:** Does this need to exist to stay competitive?
- **Technical leverage:** Does building this create reusable infrastructure?

### 5. Risk Flags
- Scope creep potential (how likely is this to grow?)
- Edge cases and complexity that emerge during build
- Dependencies on external teams or systems
- Potential negative side effects on existing users

## Output Format

```
## 🎯 Feature Validator — [Feature Name]

### 💰 User Value
- **Pain point:** [Description]
- **Target users:** [Who, estimated how many]
- **Frequency:** [Daily / Weekly / Monthly / One-time]
- **Impact:** [Critical / Major / Minor / Negligible]
- **Current workaround:** [What users do today]

### ⚙️ Development Effort
- **Time:** [XS / S / M / L / XL / XXL] — [estimated days/weeks]
- **Complexity:** [Low / Medium / High]
- **Dependencies:** [List dependencies or "None"]
- **Tech debt:** [Yes (what) / No]
- **Testing effort:** [Low / Medium / High]

### 📊 RICE Score
| Component | Value | Notes |
|---|---|---|
| Reach (users/qtr) | [X] | |
| Impact | [X] | |
| Confidence | [X]% | |
| Effort (weeks) | [X] | |
| **RICE Score** | **[X]** | |

### 🎯 Strategic Fit
- Alignment: [High / Medium / Low]
- Competitive necessity: [Must-have / Should-have / Nice-to-have]
- Enabler for: [Other features or revenue impact]

### ⚠️ Risk Flags
- [Any risks or concerns]

### 📋 Decision
| Option | When to choose |
|---|---|
| **🏗️ Build Now** | High value, reasonable effort, strategic fit |
| **📅 Backlog** | Good idea but not urgent, deprioritize for now |
| **❌ Skip** | Low impact, high effort, or better alternatives exist |
| **🔍 More Info** | Missing critical info — need user research |

**Verdict:** [Build Now / Backlog / Skip / More Info]
**Rationale:** [2-3 sentence explanation]
```

## Rules

- Ask for missing info if user value or effort is unclear — don't guess
- Be explicit about confidence level; mark assumptions clearly
- Compare against alternatives when possible
- Flag if the feature might be a symptom of a deeper problem
- Recommend "More Info" if user research or data is needed before deciding