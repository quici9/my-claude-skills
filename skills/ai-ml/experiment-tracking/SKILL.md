# Experiment Tracking

## Description

Manages ML experiment tracking using MLflow, Weights & Biases, or DVC. Records hyperparameters, metrics, artifacts, and enables reproducible comparisons across runs.

## Triggered When

- User says "track experiments", "log this run", "compare experiments"
- User says "theo dõi experiments", "log kết quả training", "so sánh các lần chạy"
- User asks "what parameters gave the best result", "compare this vs previous run"
- User says "thông số nào tốt nhất", "so sánh với lần trước", "kết quả experiment"
- User wants to set up experiment tracking for their project
- User says "MLflow setup", "WandB setup", "track this training"

## Workflow

### 1. Assess Current Setup
- Check if project has existing tracker (MLflow, WandB, TensorBoard)
- Identify framework (PyTorch, TensorFlow, scikit-learn)
- Understand what to log: params, metrics, artifacts

### 2. Set Up Tracker
- **MLflow**: `mlflow.start_run()`, autolog, or MLflow UI
- **WandB**: `wandb.init()`, `wandb.log()`
- **DVC + git**: for pipeline + data versioning

### 3. Log Strategically
- **Hyperparameters**: lr, batch_size, model config, seed
- **Metrics**: train_loss, val_loss, accuracy, F1, per-epoch
- **Artifacts**: best model checkpoint, preprocessed data, plots
- **Metadata**: git commit hash, dataset version, runtime

### 4. Organize Runs
- Use experiment names, tags (e.g., "ablation", "baseline", "prod")
- Group related runs under same project/experiment
- Log config as a single YAML/dict — not individual params

### 5. Compare & Analyze
- Use tracker UI or query API to find best run
- Compare across: different seeds, architecture changes, data versions
- Plot learning curves, metric trends

## Output Format

```
## 🧪 Experiment Tracking — [project name]

### Tracker
- Tool: [MLflow/WandB/DVC]
- Tracking URI: [uri]

### Current Best Run
- Run ID: [id]
- Params: [key values]
- Metrics: [val_accuracy, etc.]

### Comparison Summary
| Run | Params | Val Acc | Notes |
|-----|--------|---------|-------|
| run_001 | lr=1e-3 | 0.87 | baseline |
| run_002 | lr=5e-4 | 0.91 | +augmentation |

### Setup Code
[tracker initialization code]
```

## Rules

- Always log the git commit hash alongside metrics
- Name runs descriptively — avoid "run_123" as only identifier
- Save model checkpoints as artifacts, not just metrics
- Use seeded runs for reproducibility comparison
