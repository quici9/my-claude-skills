# Hyperparameter Tuning

## Description

Systematic hyperparameter optimization using grid search, random search, Bayesian optimization (Optuna, Hyperopt), and genetic algorithms. Focuses on efficient search strategies and avoiding overfitting to validation set.

## Triggered When

- User says "tune hyperparameters", "optimize this model", "find best params"
- User says "tối ưu hyperparameters", "tìm thông số tốt nhất", "tune model"
- User asks "grid search vs random search", "Bayesian optimization", "Optuna setup"
- User says "grid search", "random search", "Optuna", "Bayesian optimization"
- User wants to set up automated hyperparameter search
- User says "learning rate tuning", "search space", "tune this neural network"

## Workflow

### 1. Identify Tunable Parameters
- For each hyperparameter: range, scale (linear/log), constraint
- Categorical: list of possible values
- Integer: min/max with step
- Real: log-uniform or uniform distribution

### 2. Choose Search Strategy

| Strategy | When to use |
|---|---|
| Grid Search | <5 params, small search space |
| Random Search | Medium space, most cases |
| Bayesian (Optuna) | 5+ params, expensive eval |
| Early Stopping | Deep learning, large epochs |

### 3. Define Search Space
- Narrow ranges based on domain knowledge first
- Coarse-to-fine: wide search → narrow around best region
- Fix insensitive params at reasonable defaults

### 4. Avoid Overfitting to Val Set
- Use nested CV or hold-out set not used in tuning
- Limit number of trials (budget-aware)
- Report tuned metric on unseen test set

### 5. Analyze Results
- Feature importance of hyperparameters (if Bayesian)
- Partial dependence plots
- Sensitivity analysis: which params matter most

## Search Space Template

```python
# Optuna example
search_space = {
    "lr": trial.suggest_float("lr", 1e-5, 1e-1, log=True),
    "batch_size": trial.suggest_categorical("batch_size", [16, 32, 64, 128]),
    "n_estimators": trial.suggest_int("n_estimators", 50, 500),
    "max_depth": trial.suggest_int("max_depth", 3, 15),
    "min_child_weight": trial.suggest_int("min_child_weight", 1, 10),
}
```

## Output Format

```
## 🎛️ Hyperparameter Tuning — [model name]

### Search Strategy
- Method: [Optuna/Random/Grid]
- Trials: [N]
- Time budget: [duration]

### Best Configuration Found
| Param | Best Value | Search Range |
|-------|------------|--------------|
| lr    | 3.2e-4     | [1e-5, 1e-1] |
| ...   | ...        | ...          |

### Performance
- Best Val Metric: [value]
- vs Default Params: [delta]
- Tuned on: [dataset split]

### Key Findings
- Most impactful param: [name]
- Least sensitive param: [name]
- Recommended defaults for next experiment: [list]

### Code
[Optuna/Hyperopt objective function code]
```

## Rules

- Never tune on test set — use nested CV or separate hold-out
- Log all trial results, not just the best
- Report results with confidence intervals when possible
- Start with reasonable defaults, narrow search around them
