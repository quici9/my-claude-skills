# Investment Analysis

## Description

Compare investment channels, calculate ROI, assess risk-return profiles, and support portfolio decisions. Covers stocks, crypto, real estate, bonds, mutual funds, P2P lending, and alternative assets. Supports Vietnamese market context.

## Triggered When

- User shares investment options and asks "which is better?", "compare these investments"
- User says "đầu tư gì tốt hơn", "so sánh các kênh đầu tư", "nên đầu tư gì"
- User asks "what's the ROI of X?", "calculate returns for Y"
- User says "tính ROI", "lợi nhuận bao nhiêu", "hoàn vốn bao lâu"
- User asks about risk of a specific investment type or asset
- User says "rủi ro như thế nào", "có rủi ro gì", "mức độ rủi ro"
- User asks "should I invest in X?" or "is Y a good investment?"
- User asks about portfolio diversification, asset allocation
- User says "đa dạng hóa danh mục", "phân bổ tài sản"
- User asks "how much do I need to retire?", "FIRE calculations", "bao nhiêu để nghỉ hưu"

## Analysis Framework

### 1. Gather Information
- Asset type, entry price, expected holding period
- Expected returns (conservative/base/optimistic)
- Initial capital, ongoing contributions
- User's risk tolerance (Conservative / Moderate / Aggressive)
- Time horizon (short <2yr / medium 2-5yr / long >5yr)

### 2. ROI Calculation
```
Annual Return = (Ending Value - Beginning Value - Costs) / Beginning Value × 100
CAGR = (Ending Value / Beginning Value)^(1/years) - 1
Risk-Adjusted Return = Annual Return / Volatility (Sharpe Ratio proxy)
```

### 3. Risk Assessment (1-10 scale)
| Risk Factor | Low (1-3) | Medium (4-6) | High (7-10) |
|---|---|---|---|
| Volatility | < 5% | 5–15% | > 15% |
| Liquidity | High (daily) | Medium (weeks) | Low (months+) |
| Complexity | Simple | Moderate | Complex/leveraged |
| Market dependency | Low | Medium | High |
| Regulatory risk | Low | Medium | High |

### 4. Vietnamese Market Context
- Stock: VN-Index, HNX, UPCOM tickers; SSI, VND, MBS brokers
- Real estate: land tax, ownership rules for foreigners
- P2P lending: legal grey area as of 2026 — flag clearly
- Crypto: not regulated — high risk warning required
- Bank interest: current ~4-6% p.a. for 12-month VND deposits

## Output Format

```
## 📊 Investment Analysis — [Asset/Option Name]

### 🔢 Basic Metrics
- Entry: [price]
- Expected Return: [conservative] / [base] / [optimistic]
- Holding Period: [X years]
- Estimated ROI: [X%] | CAGR: [X%]

### ⚖️ Risk Profile
- Overall Risk: [Low / Medium / High] — [score]/10
- Volatility: [X%]
- Liquidity: [High / Medium / Low]
- Key risks:
  - ...
  - ...

### 📈 Comparison (vs alternatives)
| Metric | This Asset | [Alt 1] | [Alt 2] |
|---|---|---|---|
| Expected ROI | X% | X% | X% |
| Risk (1-10) | X | X | X |
| Liquidity | High | Med | Low |
| Min. investment | $X | $X | $X |

### ✅ Recommendation
[Verdict: Invest / Consider / Avoid / More info needed]
**Rationale:** [2-3 sentence explanation]

### ⚠️ Key Flags
- [Flag specific risks or concerns]

### 💡 Next Steps
1. [Actionable next step]
2. [Actionable next step]
```

## Rules

- Always flag unregulated investments (crypto, P2P) with ⚠️ warnings
- Ask for missing info before giving definitive advice
- Use Vietnamese market context (VND, VN-Index, local brokers)
- Present both sides — upside AND downside clearly stated
- Never say "guaranteed" or imply certainty about returns
- If user lacks a risk profile, prompt them first before analyzing
