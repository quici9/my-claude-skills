# Financial Goal Tracker

## Description

Track progress toward short-term and long-term financial goals (emergency fund, house down payment, retirement, FIRE, travel, etc.). Calculate required savings rate, projected timelines, and alert when goals are at risk. Supports both lump-sum and recurring contributions.

## Triggered When

- User says "track my financial goals", "how am I doing on my goal?"
- User says "theo dõi mục tiêu tài chính", "tiến độ tiết kiệm của tôi"
- User sets a new financial goal ("I want to save X by Y date")
- User says "muốn tiết kiệm X vào ngày Y", "đặt mục tiêu tài chính"
- User asks "can I reach X by Y date?" or "how long until I reach X?"
- User says "có đạt được không", "bao lâu nữa", "đến lúc đó có xong không"
- User asks "how much do I need to save per month for X?", "cần tiết kiệm bao nhiêu mỗi tháng"
- User shares goal progress and asks for analysis/advice
- User asks about FIRE calculations, "bao nhiêu để FIRE"

## Goal Categories

| Type | Time Horizon | Typical Examples |
|---|---|---|
| Short-term | < 1 year | Vacation, new phone, emergency fund starter |
| Medium-term | 1–5 years | House down payment, car, wedding, career transition fund |
| Long-term | 5+ years | Retirement, kid's education, early retirement |
| Ongoing | Continuous | Emergency fund (always top up), investment portfolio |

## Key Calculations

### Monthly Savings Required
```
Monthly Savings = (Goal Amount - Current Savings) / Months Remaining
```

### Projected Completion Date
```
Months to Goal = (Goal Amount - Current Savings) / Monthly Contribution
Final Date = Today + Months to Goal
```

### FIRE Number
```
FIRE Number = Annual Expenses × 25 (4% safe withdrawal rate)
Or: × 33 (3% conservative SWR for early retirement)
```

### Goal Health Score
| Score | Status | Meaning |
|---|---|---|
| 90–100% | 🟢 On Track | Projected to reach goal on time |
| 70–89% | 🟡 Slightly Behind | May need slight adjustment |
| 50–69% | 🟠 Behind | Significant gap — review needed |
| < 50% | 🔴 At Risk | Goal unlikely without major changes |

## Input Format (User Provides)

```
Goal: [name]
Target Amount: [VND or $]
Current Amount: [VND or $]
Target Date: [month/year]
Monthly Contribution: [VND/mo]
Expected Interest/Return: [% p.a.]
```

## Output Format

```
## 🎯 Financial Goal: [Goal Name]

### 📊 Current Status
| Field | Value |
|---|---|
| Target Amount | XX,XXX,XXX VND |
| Current Amount | XX,XXX,XXX VND |
| Remaining | XX,XXX,XXX VND |
| Progress | XX% funded |
| Target Date | [Month YYYY] |
| Days Remaining | [X days] |
| Monthly Contribution | XX,XXX,XXX VND |
| Expected Return | X% p.a. |

### 📈 Projection
```
On current track:  [Month YYYY]  ⚠️ [X months late] or ✅ [on track]
Required monthly:  XX,XXX,XXX VND/mo
Current monthly:   XX,XXX,XXX VND/mo
Gap:               ±XX,XXX,XXX VND/mo
```

### 🟢 Goal Health Score: [XX/100] — [Status]
- Progress vs. time elapsed: [X%] vs [Y%] elapsed
- [2-3 sentence assessment]

### 📉 Scenario Analysis
| Scenario | Monthly | Completion | vs Target |
|---|---|---|---|
| Current | XX,XXX,XXX | Month YYYY | [±X mo] |
| +10% contribution | XX,XXX,XXX | Month YYYY | [±X mo] |
| +25% contribution | XX,XXX,XXX | Month YYYY | [±X mo] |
| [Aggressive — X% return] | XX,XXX,XXX | Month YYYY | [±X mo] |

### 💡 Recommendations
1. **[Biggest lever]** [Specific action to improve goal outlook]
2. **[Quick win]** [Low-effort adjustment]
3. **[If at risk]** [What needs to change and why]

### 📋 All Goals Overview
| Goal | Progress | Target | Monthly | Health |
|---|---|---|---|---|
| Emergency Fund | 60% | 90M | 3M/mo | 🟡 78/100 |
| House Down Payment | 25% | 500M | 10M/mo | 🔴 45/100 |
| FIRE | 15% | 2B | 8M/mo | 🟡 65/100 |
```

## Rules

- Always show both the "on current track" projection AND "what's needed" to close the gap
- If goal is at risk, lead with that — don't bury it
- Use Vietnamese VND formatting (e.g., 2,5 tỷ = 2,500,000,000 VND)
- Flag if total monthly goal contributions exceed 30% of income
- Ask user to confirm goal priorities if they have multiple goals
- FIRE calculations: always show both 4% (standard) and 3% (conservative) SWR
