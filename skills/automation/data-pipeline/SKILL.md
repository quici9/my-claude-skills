# Data Pipeline

## Description

Builds ETL/ELT data pipelines for batch and streaming data: extract from APIs/databases/files, transform with validation, and load into data warehouses, databases, or file storage. Covers pandas, dlt, Apache Airflow, and cron-based pipelines.

## Triggered When

- User says "build ETL pipeline", "data pipeline", "ETL workflow"
- User says "xây dựng ETL pipeline", "đồng bộ data", "luồng dữ liệu"
- User asks "load data from API to DB", "sync data between systems"
- User says "load data từ API vào DB", "đồng bộ giữa các hệ thống", "data warehouse"
- User wants to process files in batch (CSV, JSON, Parquet)
- User says "airflow DAG", "cron ETL", "schedule data sync"

## Workflow

### 1. Understand Data Sources & Destinations
- Source: API (REST/GraphQL), database (SQL), file storage (S3/GCS), stream (Kafka)
- Destination: data warehouse (BigQuery, Snowflake), database, file store
- Frequency: real-time, hourly, daily, weekly
- Volume: small (<10K rows), medium, large (>1M rows)

### 2. Design Extraction
- Incremental: use timestamp or ID cursor to avoid full re-fetch
- Full refresh: when to use (schema change, backfill)
- API: pagination, rate limiting, retry with backoff
- Parallel extraction for large sources

### 3. Design Transformation
- Data type casting and validation
- Deduplication (primary key check)
- Business logic: filtering, aggregation, enrichment
- Schema enforcement (enforce at load, not silently fail)

### 4. Design Loading
- Upsert (insert + update) vs append vs replace
- Target schema: create tables if not exist
- Load in batches for large datasets
- Commit atomically (all-or-nothing)

### 5. Error Handling & Monitoring
- Dead letter queue for failed records
- Alert on data quality issues (row count drift, null spike)
- Log each stage: rows extracted, transformed, loaded

### 6. Tool Selection

| Scenario | Tool |
|---|---|
| Simple Python ETL | pandas + schedule/cron |
| Production-grade | dlt, Apache Airflow, Dagster |
| Cloud data warehouse | BigQuery, Snowflake native loaders |
| Real-time / streaming | Kafka, Flink, dbt |

## Output Format

```
## 🔄 Data Pipeline — [pipeline name]

### Architecture
- Source: [system]
- Destination: [system]
- Frequency: [real-time/hourly/daily]

### Pipeline Stages
1. Extract: [method] → [N rows/snapshot]
2. Transform: [logic] → [N rows output]
3. Load: [method] → [destination table/file]

### Data Quality
- Schema validated: [yes/no]
- Duplicate check: [key column]
- Row count validation: [threshold]

### Monitoring
- Alerts: [what triggers alert]
- Dead letter queue: [yes/no]

### Code / Config
[pipeline code or DAG YAML]
```

## Rules

- Always log row counts at each stage — the first sign of a bad pipeline is a missing row
- Incremental extraction is preferred over full refresh unless necessary
- Separate credentials from pipeline code — use env vars or secret manager
- Test pipeline on sample data before deploying
