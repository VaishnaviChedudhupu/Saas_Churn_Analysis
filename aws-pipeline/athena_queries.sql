1. Sanity check (expect 7,043 customers and a 26.54% churn rate, matching your script’s report):
   SELECT COUNT(*) AS total_customers,
          ROUND(AVG(churn_flag) * 100, 2) AS churn_rate_pct
   FROM churn_clean;
2. Churn by contract type:
   SELECT contract,
          COUNT(*) AS customers,
          ROUND(AVG(churn_flag) * 100, 2) AS churn_rate_pct
   FROM churn_clean
   GROUP BY contract
   ORDER BY churn_rate_pct DESC;
3. Churn by tenure bucket:
   SELECT CASE WHEN tenure < 12 THEN '1: 0-11 months'
               WHEN tenure < 24 THEN '2: 12-23 months'
               WHEN tenure < 48 THEN '3: 24-47 months'
               ELSE '4: 48+ months' END AS tenure_bucket,
          COUNT(*) AS customers,
          ROUND(AVG(churn_flag) * 100, 2) AS churn_rate_pct
   FROM churn_clean
   GROUP BY 1
   ORDER BY 1;
4. Your resume finding (month-to-month under 12 months; your resume says about 51%):
   SELECT COUNT(*) AS customers,
          ROUND(AVG(churn_flag) * 100, 2) AS churn_rate_pct
   FROM churn_clean
   WHERE contract = 'Month-to-month' AND tenure < 12;
5. Monthly revenue at risk (active customers on short month-to-month contracts):
   SELECT COUNT(*) AS active_customers,
          ROUND(SUM(monthlycharges), 2) AS monthly_revenue_at_risk
   FROM churn_clean
   WHERE churn = 'No' AND contract = 'Month-to-month' AND tenure < 12;