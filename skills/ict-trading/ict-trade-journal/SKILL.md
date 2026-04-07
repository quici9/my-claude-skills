# ICT Trade Journal & Review

## Description

Structured journaling for ICT trading. Records every trade setup, execution, and outcome for weekly/monthly analysis. Identifies patterns in win/loss trades to improve edge over time.

## Triggered When

- User says "log this trade", "record trade", "trade journal"
- User says "ghi lệnh này", "nhật ký giao dịch", "lưu trade"
- After closing a trade (win or loss)
- User says "weekly review", "monthly review", "analyze my trades"
- User says "review tuần này", "phân tích trades tuần này"
- User asks "what's my win rate", "am I profitable", "tỷ lệ thắng bao nhiêu"
- User asks "what's my win rate", "tôi có lãi không", "chỉ ra lỗi sai của tôi"

## Trade Log Entry Template

For EVERY trade, fill in immediately after entry:

```
## 📝 Trade Log Entry

### Setup Info (before entry)
- Date/Time: YYYY-MM-DD HH:MM EST
- Session: [London Killzone / NY Killzone / Other]
- Pair: [e.g. EUR/USD]
- Direction: [Long / Short]
- Timeframe(s): [e.g. 4H, 1H, 15M]

### Pre-Trade Analysis
- Order Block identified: [Yes/No] — [location]
- FVG identified: [Yes/No] — [location]
- BOS/CHoCH: [Confirmed / Not confirmed]
- Killzone alignment: [Yes/No]

### Entry
- Entry type: [Market / Limit]
- Entry price: ____
- Stop Loss: ____ (___ pips from entry)
- Target 1: ____ (R:R = 1:___)
- Target 2: ____ (R:R = 1:___)
- Position size: ____ lots
- Risk amount: $___ (% of account: ___%)

### Execution Quality
| Element | Rating | Notes |
|---|---|---|
| Entry timing | 🟢/🟡/🔴 | Did I enter at the planned zone? |
| Stop placement | 🟢/🟡/🔴 | Based on ICT rules? |
| Position size | 🟢/🟡/🔴 | Followed risk rules? |
| R:R ratio | 🟢/🟡/🔴 | Met 1:1.5 minimum? |

### Outcome
- Result: [WIN / LOSS / BE / Skipped]
- Closed at: ____ (T1 / T2 / SL / Manual exit)
- P&L: $___ (___ pips)
- Outcome rating: 🟢/🟡/🔴

### Post-Trade Reflection
- What went well: ...
- What went wrong: ...
- Did I follow my plan? [Yes / Partially / No]
- Key lesson: ...
- Would I take this trade again? [Yes / No / With modifications]
```

## Weekly Review Template

Run every Sunday (or end of trading week):

```
## 📊 Weekly Review — Week of YYYY-MM-DD

### Summary
| Metric | Value |
|---|---|
| Total trades | X |
| Wins | X (X%) |
| Losses | X (X%) |
| Breakeven | X |
| Skipped (no trade) | X |
| Net P&L | $X |
| Win rate | X% |
| Avg R per win | X R |
| Avg R per loss | -X R |

### Best Trade
- Date: ...
- Setup: ...
- Why it worked: ...

### Worst Trade
- Date: ...
- Setup: ...
- What went wrong: ...

### Pattern Analysis
**Wins tend to have:**
- [pattern observed]

**Losses tend to have:**
- [pattern observed]

**Things to do MORE of:**
1. ...

**Things to STOP doing:**
1. ...

### Streak Status
- Current: [X wins / X losses]
- Trading status: [GREEN / STOP]

### Week Rating: 🟢/🟡/🔴
### Focus for next week:
1. ...
```

## Monthly Review Template

```
## 📊 Monthly Review — [Month Year]

### Performance Summary
- Total trades: X
- Win rate: X%
- Net P&L: $X (X R)
- Best week: Week X (+$X)
- Worst week: Week X (-$X)
- Longest win streak: X
- Longest loss streak: X

### P&L by Session
| Session | Trades | Win% | Avg R |
|---|---|---|---|
| London Killzone | X | X% | X R |
| NY Killzone | X | X% | X R |
| Other | X | X% | X R |

### Edge Evaluation
- Are my setups working? [Yes/No]
- Is my risk management working? [Yes/No]
- Adjustments needed: ...

### Goal Check
- Monthly goal: $X
- Achieved: [X%]
- Next month target: $X

### Rating: 🟢/🟡/🔴
### Key insight for next month:
...
```

## Rules

- Log EVERY trade immediately — never trust memory
- Be honest in reflection — even wins can have bad process
- Include skipped trades in journal (they count as discipline data)
- Review weekly without fail — monthly is too long to wait
- Use data, not emotion — if stats say something, believe the data
