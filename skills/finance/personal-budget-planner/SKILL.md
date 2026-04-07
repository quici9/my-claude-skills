# Personal Budget Planner

## Description

Help users create, track, and adjust monthly/annual personal budgets. Supports Vietnamese income patterns (salary, freelance, business), common expense categories, and savings goals. Works with or without transaction data.

## Triggered When

- User says "help me budget", "plan my monthly budget", "set up a budget"
- User says "lập ngân sách", "lên kế hoạch chi tiêu", "quản lý tiền bạc"
- User shares income and expenses and asks "is this sustainable?", "có bền vững không"
- User asks "how much should I save?", "am I spending too much on X?"
- User says "nên tiết kiệm bao nhiêu", "chi tiêu quá nhiều cho mục này không"
- User asks to review or optimize an existing budget
- User says "tối ưu ngân sách", "cắt giảm chi tiêu"
- User asks about reducing expenses in a specific category
- User asks "what's a good spending breakdown?" or "50/30/20 rule", "tỷ lệ chi tiêu tốt"

## Budget Frameworks

### 50/30/20 Rule (default starting point)
| Category | % | Description |
|---|---|---|
| Needs | 50% | Housing, utilities, groceries, transport, insurance, minimum debt |
| Wants | 30% | Dining out, entertainment, subscriptions, hobbies, shopping |
| Savings/Debt | 20% | Emergency fund, investments, extra debt payment, goals |

### Adjusted Ratios by Income Level
- **Low income (< VND 15M/mo):** 60/20/20 — prioritize needs + savings
- **Mid income (VND 15-40M/mo):** 50/25/25 — balanced
- **High income (> VND 40M/mo):** 40/30/30 — maximize savings/investments

### Vietnamese Expense Categories
```
INCOME
├── Salary (nhân viên)
├── Freelance / Hợp đồng
├── Business revenue
├── Investment income (cổ tức, lãi)
└── Other

NEEDS
├── Housing (thuê nhà / trả góp) — max 30% income
├── Utilities (điện, nước, internet, điện thoại)
├── Groceries (thực phẩm, nhu cầu thiết yếu)
├── Transport (xăng, xe máy / ô tô, bảo hiểm xe)
├── Insurance (y tế, nhân thọ, vật chất)
├── Health (khám bệnh, thuốc men)
├── Education (học phí, khóa học — thiết yếu)
├── Debt repayment (minimum)
└── Other essentials

WANTS
├── Dining out, coffee, delivery
├── Entertainment (movies, streaming, gaming)
├── Shopping (clothes, electronics, non-essentials)
├── Subscriptions (Netflix, Spotify, gym)
├── Travel, vacation
├── Hobbies
└── Gifts, donations

SAVINGS & GOALS
├── Emergency fund (3-6 months expenses)
├── Short-term goal (< 1 year)
├── Long-term goal (1-5 years)
├── Retirement / FIRE fund
├── Investment contributions
└── Debt extra payment
```

## Output Format

### Monthly Budget Template (filled)
```
## 💰 Monthly Budget — [Month/Year]

### Income
| Source | Amount (VND) |
|---|---|
| Salary | X,XXX,XXX |
| Freelance | X,XXX,XXX |
| Other | X,XXX,XXX |
| **Total Income** | **XX,XXX,XXX** |

### Budget Breakdown
| Category | Target (VND) | Target (%) | Notes |
|---|---|---|---|
| 🏠 Housing | X,XXX,XXX | XX% | max 30% |
| 🚗 Transport | X,XXX,XXX | XX% | |
| 🍎 Groceries | X,XXX,XXX | XX% | |
| ⚡ Utilities | X,XXX,XXX | XX% | |
| 🏥 Health | X,XXX,XXX | XX% | |
| 📦 Other Needs | X,XXX,XXX | XX% | |
| **Total Needs** | **XX,XXX,XXX** | **XX%** | target ≤50% |
| 🍽️ Dining Out | X,XXX,XXX | XX% | |
| 🎬 Entertainment | X,XXX,XXX | XX% | |
| 🛍️ Shopping | X,XXX,XXX | XX% | |
| ✈️ Travel | X,XXX,XXX | XX% | |
| **Total Wants** | **XX,XXX,XXX** | **XX%** | target ≤30% |
| 🏦 Emergency Fund | X,XXX,XXX | XX% | |
| 🎯 Goals | X,XXX,XXX | XX% | |
| 📈 Investments | X,XXX,XXX | XX% | |
| **Total Savings** | **XX,XXX,XXX** | **XX%** | target ≥20% |
| **Total Allocated** | **XX,XXX,XXX** | **100%** | |

### Health Check
- ✅ / ⚠️ Needs ratio: [X%] — [on/off target]
- ✅ / ⚠️ Wants ratio: [X%] — [on/off target]
- ✅ / ⚠️ Savings ratio: [X%] — [on/off target]
```

### Optimization Suggestions
```
### 🔧 Optimization Tips
1. **[Biggest win]** [Category]: currently [X%], reduce to [Y%]
   → Saves: [Z VND/mo] → [Z × 12 VND/yr]
2. [Next actionable suggestion]
3. [Quick win — low effort, visible impact]
```

## Rules

- Always ask for monthly income if not provided
- Flag if any category exceeds recommended percentages
- Show the yearly impact of overspending/undersaving
- For zero-income months (sabbatical, job loss), flag emergency fund needs
- Respect user's priorities — budget is personal, not moral judgment
- If expenses exceed income, lead with "here's how to get back to balance"
