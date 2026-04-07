# ML Pipeline

## Description

Builds end-to-end ML pipelines: data ingestion → preprocessing → training → evaluation → inference → deployment. Uses modern tools (scikit-learn Pipeline, ZenML, Kubeflow, Metaflow) with reproducibility and monitoring built in.

## Triggered When

- User says "build ML pipeline", "automate training pipeline", "set up ML workflow"
- User says "xây dựng ML pipeline", "tự động hóa training", "workflow ML"
- User asks "how to deploy this model", "CI/CD for ML", "model serving"
- User says "deploy model", "model serving", "CI/CD cho ML", "production ML"
- User wants to chain data processing + training + evaluation steps
- User says "MLflow pipeline", "Kedro pipeline", "airflow for ML"

## Pipeline Design

### Standard Stages

```
1. Data Ingestion    → load from DB/S3/API
2. Data Validation   → schema check, drift detection
3. Data Preprocessing → feature engineering, scaling
4. Model Training     → train with config, log experiment
5. Model Evaluation   → validate on hold-out, threshold tuning
6. Model Registry    → save best model, tag version
7. Inference / Serving → batch or real-time prediction
8. Monitoring        → track performance, detect drift
```

### Tool Selection

| Use case | Recommended tool |
|---|---|
| Quick prototype | scikit-learn Pipeline + joblib |
| Reproducible research | ZenML, Metaflow |
| Production / K8s | Kubeflow Pipelines, Airflow |
| Cloud-native | AWS SageMaker Pipelines, Vertex AI |
| Experiment tracking only | MLflow + Python scripts |

### Key Principles
- **Idempotent**: running pipeline twice with same data → same result
- **Config-driven**: no hardcoded paths, params in YAML/CLI args
- **Reproducible**: lock dependencies (requirements.txt, conda env)
- **Monitored**: log data stats at each stage, detect drift

## Pipeline Template (scikit-learn)

```python
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.model_selection import cross_val_score

pipeline = Pipeline([
    ("preprocess", PreprocessingTransformer()),
    ("scale", StandardScaler()),
    ("clf", GradientBoostingClassifier()),
])

# Tune using pipeline directly
param_grid = {
    "clf__n_estimators": [100, 200],
    "clf__learning_rate": [0.05, 0.1],
}
```

## Output Format

```
## 🔧 ML Pipeline — [project name]

### Pipeline Architecture
1. [Stage name] → [tool] → [output artifact]
2. ...

### Tools Used
- Orchestration: [tool]
- Experiment tracking: [tool]
- Data versioning: [tool]

### Reproducibility
- Environment lock: [file]
- Config file: [file]
- Git commit: [hash]

### Monitoring
- Metrics tracked: [list]
- Drift detection: [yes/no] — method: [method]

### Deployment
- Mode: [batch/realtime]
- Endpoint: [url or schedule]

### Code Structure
[pipeline code scaffold]
```

## Rules

- Every pipeline run should produce a unique run ID and be logged
- Save intermediate artifacts (preprocessed data, model checkpoints)
- Separate config from code — no magic numbers in pipeline steps
- Test pipeline on small sample before full run
