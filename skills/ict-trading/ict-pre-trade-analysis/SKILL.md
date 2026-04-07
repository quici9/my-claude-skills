# ICT Pre-Trade Analysis

## Description

Structured pre-trade analysis using ICT methodology — Order Blocks (OB), Fair Value Gaps (FVG), Balance of Supply/Demand (BOS), and Change of Character (CHoCH). Applies London and New York Killzone context to identify high-probability setups with clear entry, stop, and target zones.

## Triggered When

- User says "analyze this chart", "pre-trade analysis", "phân tích chart này"
- User says "ICT setup", "phân tích trước giao dịch", "tìm entry"
- User shares chart description, price data, or trading context
- User asks "is this a good setup", "where to enter", "nên vào lệnh ở đâu"
- User asks "stop loss ở đâu", "take profit ở đâu", "OB/FVG/BOS ở đâu"
- Before trading session: identifying setups for the day/week

## ICT Pre-Trade Checklist

### Phase 1: Time & Session Context
- [ ] Identify current session: London Killzone (02:00-03:00 EST) or NY Killzone (08:30-10:00 EST)
- [ ] Is this a first-hour session? (higher probability)
- [ ] What was the macro event/-news context?

### Phase 2: Structural Analysis

**Step 1 — Identify Market Structure**
- [ ] Current trend: Higher Highs (bullish) or Lower Lows (bearish)?
- [ ] Draw key structure lines: Swing Highs, Swing Lows
- [ ] Is price in a range or trending?

**Step 2 — Find Fair Value Gaps (FVG)**
- [ ] Identify all FVGs on the chart (1H+ timeframe)
- [ ] Classify: recently created or old/recycled?
- [ ] Which FVGs align with structural support/resistance?

**Step 3 — Find Order Blocks (OB)**
- [ ] Identify last 1-3 bullish OB (bottom wicks of down candles)
- [ ] Identify last 1-3 bearish OB (top wicks of up candles)
- [ ] Which OBs are still intact (not traded through)?

**Step 4 — Confirm BOS/CHoCH**
- [ ] Is there a BOS in the direction of trade?
- [ ] Is there a CHoCH (structure shift)?
- [ ] Is momentum confirming direction?

### Phase 3: Entry Zone Construction

**Bullish Setup Checklist**
- [ ] Price near a bullish OB (demand)?
- [ ] Bullish OB aligned with a FVG above?
- [ ] Recent bullish BOS confirming higher lows?
- [ ] Entry zone: between OB top and FVG bottom
- [ ] Stop loss: below the OB low (1-5 pips buffer)
- [ ] Target: next bearish OB or FVG fill

**Bearish Setup Checklist**
- [ ] Price near a bearish OB (supply)?
- [ ] Bearish OB aligned with a FVG below?
- [ ] Recent bearish BOS confirming lower highs?
- [ ] Entry zone: between OB bottom and FVG top
- [ ] Stop loss: above the OB high (1-5 pips buffer)
- [ ] Target: next bullish OB or FVG fill

### Phase 4: Killzone Rules

**London Killzone (02:00-03:00 EST)**
- High probability: first reaction to Asian range break
- Look for: displacement candle, FVG creation
- Avoid: trading against the first displacement

**NY Killzone (08:30-10:00 EST)**
- High probability: continuation after London
- Look for: liquidity runs before news, reversal into killzone
- Avoid: fading the 08:30 displacement candle

## Output Format

```
## 📊 ICT Pre-Trade Analysis — [Pair] [Timeframe]

### Session & Context
- Session: [London/NY Killzone]
- Trend: [Bullish/Bearish/Ranging]
- Macro: [News/event context]

### Structural Map
- HH/HL or LH/LL structure: ...
- Key levels: ...
- FVG(s) identified: ...
- OB(s) identified: ...

### Setup Quality Check
| Element | Status | Notes |
|---|---|---|
| Order Block | ✅/❌ | ... |
| FVG aligned | ✅/❌ | ... |
| BOS confirmed | ✅/❌ | ... |
| Killzone timing | ✅/❌ | ... |

### Trade Plan
- **Direction**: [Long/Short]
- **Entry Zone**: [price range]
- **Stop Loss**: [price level] (R: [X] pips)
- **Target 1**: [price] (R:R = 1:X)
- **Target 2**: [price] (R:R = 1:X)
- **Invalidation**: [price if wrong]

### Confidence Level
- 🟢 High (all boxes checked)
- 🟡 Medium (most boxes checked)
- 🔴 Low (few boxes checked)

### Notes
- ...
```

## Rules

- NEVER suggest a trade without all 4 phases completed
- Always include stop loss and invalidation point
- R:R must be minimum 1:1.5 to consider
- Distinguish between "no setup" and "bad setup"
- If killzone timing is off, flag it
