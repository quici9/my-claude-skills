# Model Evaluation

## Description

Evaluates ML model performance rigorously using appropriate metrics, confusion matrices, ROC curves, bias analysis, and statistical significance tests. Covers classification, regression, and ranking.

## Triggered When

- User says "evaluate this model", "what's the model performance", "check accuracy"
- User says "đánh giá model", "hiệu suất model", "độ chính xác bao nhiêu"
- User asks "is this model biased", "check for bias", "fairness audit"
- User says "model có thiên lệch không", "kiểm tra bias", "fairness"
- User shares test results and wants interpretation
- User says "confusion matrix", "precision recall", "ROC AUC", "regression metrics"

## Workflow

### 1. Match Metric to Problem Type

**Classification:**
- Imbalanced data → F1, PR-AUC, balanced accuracy (NOT accuracy)
- Multi-class → macro/weighted F1, per-class recall
- Ranking/probability → ROC-AUC, log loss, Brier score

**Regression:**
- Low outlier risk → RMSE, MAE
- High outlier risk → MAE, MAPE, Huber loss
- Normalized → R², adjusted R²

**Ranking:**
- Top-K recommendation → NDCG, MAP@K, Recall@K

### 2. Core Evaluation
- Confusion matrix (binary/multi-class)
- Precision, Recall, F1 per class
- ROC curve + AUC
- Prediction distribution plots

### 3. Cross-Validation
- K-Fold (standard data), Stratified K-Fold (classification)
- TimeSeriesSplit (temporal data)
- Leave-One-Out (small datasets)

### 4. Bias & Fairness Check
- Performance across demographic subgroups
- Disparate impact ratio
- Calibration plot / reliability diagram

### 5. Statistical Significance
- Compare against baseline or previous model
- McNemar's test, paired t-test, bootstrap CI

### 6. Error Analysis
- Top-5 most confident wrong predictions
- Identify patterns in failures
- Check for data labeling errors

## Output Format

```
## 📈 Model Evaluation — [model name]

### Problem Type
[type] | Metric: [primary metric used]

### Overall Performance
| Metric | Value | Baseline | Delta |
|--------|-------|----------|-------|
| F1     | 0.87  | 0.82     | +0.05 |
| AUC    | 0.93  | 0.88     | +0.05 |

### Confusion Matrix
[matrix]

### Bias Analysis
- Subgroup A: F1 = 0.90 | Subgroup B: F1 = 0.84 ⚠️ Gap = 0.06
- [Interpretation]

### Error Analysis
- Top error type: [description]
- Likely cause: [hypothesis]

### Recommendation
[continue/deploy/retrain/fairness-fix]
```

## Rules

- Never evaluate on training data — use held-out test set
- Always report confidence intervals, not just point estimates
- Flag if test set is too small (<100 samples per class) for reliable conclusions
- Distinguish statistical significance from practical significance
