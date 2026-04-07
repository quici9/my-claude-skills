# Data Preprocessing

## Description

Expert in data cleaning, normalization, and feature engineering for ML projects. Handles tabular, time-series, and text data with Python (pandas, scikit-learn, polars).

## Triggered When

- User says "preprocess data", "clean data", "feature engineering"
- User says "làm sạch data", "tiền xử lý data", "tạo features"
- User shares raw data and wants it ready for ML
- User says "missing values", "giá trị thiếu", "outliers", "chuẩn hóa"
- User says "encode categorical", "train test split", "scale features", "chia data"
- User asks "normalize this", "handle missing values", "encode features"
- User says "prepare training data", "build dataset", "transform features"

## Workflow

### 1. Diagnose Data
- Shape, dtypes, null counts, duplicates
- Identify column types: numeric, categorical, datetime, text, ID
- Spot outliers, class imbalance, data leakage risk

### 2. Handle Missing Values
- Numeric: mean/median imputation, KNN, or model-based
- Categorical: mode, "Unknown", or model-based
- High null (>50%): consider dropping with rationale

### 3. Handle Outliers
- Numeric: IQR, Z-score, or domain-aware clipping
- Don't remove outliers blindly — check if real or error

### 4. Feature Engineering
- Numeric: log transform, binning, polynomial features
- Categorical: one-hot, ordinal encoding, target encoding
- Datetime: extract year, month, day, weekday, lag features
- Time-series: rolling window, difference, lag features
- Text: TF-IDF, embeddings, keyword extraction

### 5. Scaling & Transformation
- StandardScaler, MinMaxScaler, RobustScaler
- Apply fit on train, transform on val/test — NEVER fit on full data

### 6. Train/Val/Test Split
- Stratified split for classification
- Time-based split for time-series
- Ensure no leakage between splits

## Output Format

```
## 📊 Data Preprocessing — [dataset name]

### Data Diagnosis
- Shape: X rows × Y cols
- Issues found: [list]

### Transformations Applied
1. [Name] — rationale
2. [Name] — rationale

### Feature Engineering
- New features created: [list]

### Train/Val/Test Split
- Train: N (X%) | Val: N (X%) | Test: N (X%)
- Method: [random/stratified/time-based]

### Code
[pandas/sklearn code block]
```

## Rules

- Always separate train/val/test BEFORE preprocessing
- Show before/after stats for key transformations
- Prefer reproducible pipelines (sklearn Pipeline) over ad-hoc code
- Flag data leakage risk immediately
