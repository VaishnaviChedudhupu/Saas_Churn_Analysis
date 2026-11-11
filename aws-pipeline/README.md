# ☁️ Churn Pipeline on AWS (S3 → Glue → Athena → ML)

## Overview
This folder extends the SaaS Customer Churn project to AWS. Raw data lands in S3, is cleaned and validated with Python, cataloged with Glue, queried with Athena SQL, and used to train a Logistic Regression model.

## Architecture
Raw CSV (S3) → Python cleaning with Pandas and boto3 → Parquet (S3) → Glue Crawler → Athena SQL → Logistic Regression (scikit-learn)

## Dataset
Telco Customer Churn (Kaggle), 7,043 customers, used as subscription-style churn data.

## Tools
AWS S3, AWS Glue, Amazon Athena, AWS CloudShell, Python (Pandas, boto3, scikit-learn), SQL

## Pipeline Steps
1. **Ingest:** the raw CSV is stored in an S3 raw bucket.
2. **Clean and validate** (`clean_churn.py`): reads from S3, standardizes columns, converts `TotalCharges` to numeric, checks duplicates and nulls, reconciles row counts, and writes Parquet plus a data-quality report to S3.
3. **Catalog:** a Glue Crawler reads the Parquet folder and creates the `churn_clean` table in the Glue Data Catalog.
4. **Query** (`athena_queries.sql`): Athena runs SQL directly on the data in S3.
5. **Model** (`model_churn.py`): pulls the full table from Athena and trains a Logistic Regression model. Metrics are saved back to S3.

## Data Quality Results
| Check | Result |
|---|---|
| Raw rows → clean rows | 7,043 → 7,043 (reconciled) |
| Duplicates removed | 0 |
| Blank TotalCharges fixed | 11 (all customers with 0 tenure, set to 0) |
| Nulls remaining | 0 |

## Athena Findings
- Overall churn rate: **26.54%**
- Churn by contract: Month-to-month **42.71%**, One year **11.27%**, Two year **2.83%**
- Month-to-month customers with tenure under 12 months: **1,908 customers, 51.94% churn** (about 2x the overall rate)

## Model Results (Logistic Regression, 80/20 split)
| Metric | Value |
|---|---|
| Accuracy | 80.62% |
| Precision | 65.93% |
| Recall | 55.88% |
| F1-score | 60.49% |
| ROC-AUC | 0.842 |

**Limitation:** recall is about 56%, so the model misses nearly half of the customers who churn. Improving it would need class weighting or threshold tuning.

## Screenshots
![S3 buckets](screenshots/s3-buckets.png)
![Glue table](screenshots/glue-table.png)
![Athena churn by contract](screenshots/athena-contract.png)
![Athena month-to-month under 12 months](screenshots/athena-month-to-month.png)
![Data quality report](screenshots/dq-report.png)
![Model metrics](screenshots/model-metrics.png)

## How to Run
1. Create three S3 buckets: raw, clean, and Athena results.
2. Upload the raw CSV to the raw bucket and run `python3 clean_churn.py`.
3. Run a Glue Crawler on the `churn_clean/` folder, then run the queries in `athena_queries.sql`.
4. Run `python3 model_churn.py`.

## Author
Vaishnavi Chedudhupu
