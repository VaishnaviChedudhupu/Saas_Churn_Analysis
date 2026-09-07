# 📉 SaaS Customer Churn Analytics | End-to-End ETL Pipeline

## 📌 Project Overview
This project is an end-to-end data pipeline analyzing customer churn for a SaaS 
subscription business. Unlike a typical single-file dashboard, this project moves 
data through a full ETL flow — from a SQL source database, through Power Query 
transformation and validation, into a Power BI dashboard with a custom-built and 
statistically validated churn risk score.

## 🔄 Pipeline Architecture
**SQL (MySQL) → Power Query (ETL) → Power BI (KPIs, Risk Scoring, Dashboard) → Python (Statistical Validation)**

## 📊 Dashboard Pages

### Page 1 — Overview
**KPIs:** Total Customers, Churn Rate, Total Revenue at Risk, Average Tenure, 
Churned Customers, Avg Monthly Charges

**Visuals:**
- Churn Rate by Contract Type
- Churn Rate by Tenure Group
- Risk Tier Distribution (Low / Medium / High)

### Page 2 — Risk Deep Dive
**Visuals:**
- Churn Rate by Number of Subscribed Services
- Churn Rate by Payment Method
- Tenure Group × Contract Type Risk Matrix
- Top 20 Highest-Risk Active Customers (actionable retention list)
- Revenue by Risk Tier

## 🛠 Tools Used
MySQL, Power BI Desktop, Power Query, DAX, Python (Pandas, SciPy)

## 📂 Data Pipeline

### 1. Extract (SQL)
- Raw Telco Customer Churn dataset (Kaggle, ~7,043 records) loaded into a MySQL 
  database using `LOAD DATA INFILE`
- Source row count verified: 7,043 rows

### 2. Transform (Power Query)
**Cleaning:**
- Converted `TotalCharges` from text to numeric; resolved blank values for 
  brand-new customers (0 months tenure) by setting them to 0
- Verified `customerID` had zero duplicates across all 7,043 rows
- Confirmed categorical fields (Churn, Contract, PaymentMethod, PaperlessBilling) 
  contained only expected values

**Feature Engineering:**
- `TenureGroup` — binned tenure into 0-12 / 13-24 / 25-48 / 49+ months
- `NumServices` — count of subscribed add-on services per customer
- `AvgMonthlySpend` — TotalCharges ÷ tenure, used as a cross-check against 
  MonthlyCharges

### 3. Data Quality Report
| Check | Result |
|---|---|
| Row-count reconciliation | 7,043 rows (SQL) → 7,043 rows (Power Query) — no data loss |
| Null audit | 0 empty values in tenure, MonthlyCharges, Churn |
| Logical consistency | Confirmed all tenure = 0 customers also have TotalCharges = 0 |
| Category check | Churn, Contract, PaymentMethod, PaperlessBilling contain only expected values |

### 4. Load & Model (Power BI / DAX)
Core measures: Total Customers, Churned Customers, Churn Rate, Avg Monthly 
Charges, Total Revenue at Risk, Avg Tenure

**Churn Risk Score** (calculated column, 0–100 scale):
```dax
Churn Risk Score =
VAR TenureRisk = IF([tenure] <= 12, 40, IF([tenure] <= 24, 20, 0))
VAR ContractRisk = IF([Contract] = "Month-to-month", 40, IF([Contract] = "One year", 15, 0))
VAR ChargeRisk = IF([MonthlyCharges] > 80, 20, 0)
RETURN TenureRisk + ContractRisk + ChargeRisk
```

**Risk Tier** (Low / Medium / High), derived from the score via `SWITCH`.

### 5. Statistical Validation (Python)
Independent t-tests confirmed statistically significant differences (p < 0.001) 
between churned and retained customers across all three factors used in the 
Risk Score:

| Factor | Churned Avg | Retained Avg | t-statistic | p-value |
|---|---|---|---|---|
| Tenure (months) | 18.0 | 37.6 | -31.58 | <0.00001 |
| Monthly Charges ($) | 74.44 | 61.27 | 16.54 | <0.00001 |
| Number of Services | 1.77 | 2.14 | -7.39 | <0.00001 |

## 💡 Key Insights
- **Churn Risk Score validated against real outcomes:** churned customers 
  average 71.8 points vs. 39.5 for retained customers
- **Contract type is the strongest driver:** month-to-month customers churn at 
  over 4x the rate of annual contract holders
- **Service adoption reduces churn:** customers with 6 subscribed services 
  churn at just 5%, vs. 46% for customers with only 1 service
- **Payment method matters:** electronic check users churn at 45%, nearly 3x 
  the rate of automatic payment methods (15-17%)
- **Highest-risk segment:** customers under 12 months tenure on month-to-month 
  contracts churn at 51% — the single highest-risk combination in the dataset
- **~25% of active customers** currently fall into the High Risk tier

## 📷 Dashboard Screenshots
The `/screenshots` folder contains images of both dashboard pages.

## ⭐ Key Features
- Full ETL pipeline: SQL extraction, Power Query transformation, documented 
  data validation, Power BI load
- Custom rule-based Risk Score, validated against real outcomes and confirmed 
  via independent statistical testing (t-tests)
- Actionable output: a live, filterable list of the highest-risk active 
  customers for retention outreach
- Cross-tool validation: findings confirmed consistently across Power BI 
  visuals, DAX-based scoring, and Python statistical tests

## 🚀 Skills Demonstrated
SQL, ETL Fundamentals, Data Migration, Power Query, Data Cleaning, Data 
Wrangling, Data Validation, Quality Controls, Power BI, DAX, KPI Design, Risk 
Scoring, EDA, Statistical Analysis (t-testing), Business Intelligence

## 📌 Author
Vaishnavi Chedudhupu

Aspiring Data Analyst
