-- 7. Which income group contributes the most revenue?
SELECT cd.income_group, COUNT(DISTINCT cd.customer_id) AS total_customers,
ROUND( SUM( ct.amount), 2) AS total_revenue, ROUND( SUM( ct.amount) / COUNT( DISTINCT cd.customer_id), 2) AS avg_revenue_per_customer
FROM customer_transactions ct
JOIN customer_demographics cd
ON ct.customer_id = cd.customer_id
GROUP BY cd.income_group
ORDER BY total_revenue DESC;

-- 8. Customer Lifetime Value (CLV):
-- Aggregate total spend per customer, divide by years active for normalized CLV
SELECT ct.Customer_ID, SUM(ct.Amount) AS Total_Spent,
-- Assume Membership_Duration_Years or calculate via first/last transaction date -- Years active (convert days to years)
DATEDIFF(MAX(ct.Transaction_Date), MIN(ct.Transaction_Date)) / 365 AS Years_Active,
CASE 
WHEN DATEDIFF(MAX(ct.Transaction_Date), MIN(ct.Transaction_Date)) > 0
THEN SUM(ct.Amount) / (DATEDIFF(MAX(ct.Transaction_Date), MIN(ct.Transaction_Date)) / 365)
ELSE SUM(ct.Amount)
END AS CLV
FROM Customer_Transactions ct
GROUP BY ct.Customer_ID;

-- OR--NULLIF(x,0) prevents division by zero error.
SELECT ct.Customer_ID, SUM(ct.Amount) AS Total_Spent,
ROUND(SUM(ct.Amount) /NULLIF(DATEDIFF(MAX(ct.Transaction_Date), MIN(ct.Transaction_Date)) / 365, 0) ,2) AS CLV
FROM Customer_Transactions ct
GROUP BY ct.Customer_ID;

-- 9. Churn Analysis -- Overall churn rate
SELECT COUNT(*) AS Total_Customers,
SUM(CASE WHEN `Churned (Yes/No)` = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
ROUND(SUM(CASE WHEN `Churned (Yes/No)` = 'Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*)) AS Churn_Rate
FROM Churn_Labelled_Customers;

-- 10. Churn rate by region (joining demographics)
SELECT cd.Region, COUNT(*) AS Total_Customers,
SUM(CASE WHEN cl.`Churned (Yes/No)` = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
SUM(CASE WHEN cl.`Churned (Yes/No)` = 'Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*) AS Churn_Rate
FROM Customer_Demographics cd
JOIN Churn_Labelled_Customers cl ON cd.Customer_ID = cl.Customer_ID
GROUP BY cd.Region
ORDER BY Churn_Rate DESC;

-- 11. Cohort (Retention) Analysis:-- A retention cohort analysis groups customers by the time of their first purchase, then tracks how many return in subsequent periods.-- 
-- The basic steps in SQL:
-- i. Determine each customer’s first purchase date (their cohort month).
-- ii. Join this back to all transactions, so each transaction has the customer’s cohort label.
-- iii. Count distinct customers or purchases by (cohort_month, transaction_month).

-- i) Compute each customer's cohort month (first purchase month)
SELECT ct.Customer_ID, SUM(ct.Amount) AS Total_Spent, ROUND(SUM(ct.Amount) / NULLIF(DATEDIFF(MAX(ct.Transaction_Date), MIN(ct.Transaction_Date)) / 365, 0), 2) AS CLV
FROM Customer_Transactions ct
GROUP BY ct.Customer_ID;

SELECT ct.Customer_ID, SUM(ct.Amount) AS Total_Spent,
-- Years active (convert days to years)
DATEDIFF(MAX(ct.Transaction_Date), MIN(ct.Transaction_Date)) / 365 AS Years_Active,
CASE WHEN DATEDIFF(MAX(ct.Transaction_Date), MIN(ct.Transaction_Date)) > 0
THEN SUM(ct.Amount) / (DATEDIFF(MAX(ct.Transaction_Date), MIN(ct.Transaction_Date)) / 365)
ELSE SUM(ct.Amount)
END AS CLV
FROM customer_transactions ct
GROUP BY ct.Customer_ID;

WITH First_Purchase AS (
SELECT Customer_ID, MIN(Transaction_Date) AS First_Purchase_Date,
DATE_FORMAT(MIN(Transaction_Date), '%Y-%m') AS Cohort_Month
FROM Customer_Transactions
GROUP BY Customer_ID
)
, Cohort_Data AS (
SELECT ct.Customer_ID, fp.Cohort_Month,
DATE_FORMAT(ct.Transaction_Date, '%Y-%m') AS Transaction_Month,
TIMESTAMPDIFF( MONTH, fp.First_Purchase_Date, ct.Transaction_Date
) AS Months_Since_First
FROM Customer_Transactions ct
JOIN First_Purchase fp
ON ct.Customer_ID = fp.Customer_ID
)
SELECT Cohort_Month, Months_Since_First, COUNT(DISTINCT Customer_ID) AS Active_Customers
FROM Cohort_Data
GROUP BY Cohort_Month, Months_Since_First
ORDER BY Cohort_Month, Months_Since_First;