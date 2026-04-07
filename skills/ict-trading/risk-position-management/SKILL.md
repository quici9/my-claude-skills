# Risk & Position Management

## Description

Calculates position size, stop loss placement, and risk/reward ratios for ICT forex/ Futures trading. Enforces strict 0.5-1% risk per trade, 2-loss stop rule, and documents the full risk plan before every trade.

## Triggered When

- User says "calculate position size", "how much to risk"
- User says "tính position size", "bao nhiêu lot", "risk bao nhiêu"
- User asks "is this trade worth taking", "R:R ratio", "tỷ lệ lời lỗ"
- Before entering any trade
- After a losing streak (2+ losses in a row)
- User says "max risk", "position size for $X account", "tài khoản $X thì vào bao nhiêu"

## Core Rules

### Rule 1: Max Risk Per Trade
- **Standard**: 0.5% – 1% of account per trade
- **After 2 consecutive losses**: STOP trading for the session
- **Never exceed 1%** regardless of confidence

### Rule 2: Position Size Formula

**Forex (Standard account, 1 pip = $10 per lot)**
```
Position Size = (Account × Risk%) / (Stop Loss pips × Pip Value per lot)
```

**Example**:
- Account: $10,000
- Risk: 1% = $100
- Stop Loss: 50 pips
- Position Size = $100 / (50 × $10) = 0.2 lots

**Mini lot (1 mini = $1/pip)**
```
Position Size = Risk $ / (Stop Loss pips × $1)
```

### Rule 3: Stop Loss Placement (ICT Method)
- Place 1-5 pips beyond the Order Block that invalidated the trade
- Never tighten stop after entry (only widen if trade moves in your favor)
- Stop must be visible on chart (structural level, not random)

### Rule 4: R:R Ratio Requirements
- **Minimum**: 1:1.5 (at least breakeven + fees)
- **Preferred**: 1:2 or higher
- If R:R < 1:1.5, **do not take the trade**

### Rule 5: Session Loss Limit
- After **2 consecutive losses**: no new trades for minimum 1 hour or end of session
- After **3 consecutive losses**: mandatory review before resuming
- Track daily loss limit (recommended: 3-4% max daily)

## Risk Calculator

```
┌─────────────────────────────────────────────────┐
│ RISK MANAGEMENT PLAN                            │
├─────────────────────────────────────────────────┤
│ Account Balance:         $______                │
│ Risk per Trade:          % ______               │
│ Max $ at Risk:           $______                │
├─────────────────────────────────────────────────┤
│ Trade Direction:         [Long / Short]        │
│ Entry Price:             ______                 │
│ Stop Loss Price:         ______  (___ pips)     │
│ Target Price:            ______  (___ pips)     │
├─────────────────────────────────────────────────┤
│ R:R Ratio:               1 : ___               │
│ Position Size:           ___ lots               │
│ Max Loss if stopped:     $______                │
│ Max Win if hit target:   $______                │
├─────────────────────────────────────────────────┤
│ ✅ Valid trade?           [YES / NO]            │
│ Reason:                  ...                    │
└─────────────────────────────────────────────────┘
```

## Daily Risk Log

After each trade, record:

| # | Time | Pair | Direction | Entry | SL | TP | P&L ($) | P&L (%) | Notes |
|---|---|---|---|---|---|---|---|---|---|
| 1 | ... | EUR/USD | Long | 1.0850 | 1.0820 | 1.0900 | +$150 | +1.5% | Hit TP1 |

## Streak Tracker

```
Current Streak: [W/L streak count]
🔥 Wins: X | ❌ Losses: X
Status: [GREEN — Take trades] / [🔴 STOP — 2 losses, session ended]

Last 5 trades:
1. W/L — [pair] — [notes]
2. ...
```

## Output Format

```
## 💰 Risk & Position Plan

### Account Status
- Balance: $X
- Risk per trade: X% ($X)
- Daily P&L: +$X / -$X
- Consecutive losses: X

### This Trade
- Entry: X
- Stop Loss: X (X pips)
- Target: X (X pips)
- R:R: 1:X
- Position Size: X lots
- Risk Amount: $X
- Reward Amount: $X

### Decision
🟢 TAKE IT — R:R meets minimum, within risk rules
🟡 REVIEW — [reason if borderline]
🔴 SKIP — [reason: bad R:R, streak exceeded, etc.]
```

## Rules

- ALWAYS calculate BEFORE entering — never enter first, calculate later
- If R:R < 1:1.5, skip the trade — no exceptions
- If 2 losses in a row: stop, walk away, review later
- Record EVERY trade in the log, including skipped ones
- Never trade during emotional stress or after major loss
