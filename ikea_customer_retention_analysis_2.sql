-- KPI: 1. Which customers generate the highest lifetime value, normalized by their tenure? // OR -- Who are the most valuable customers when adjusted for membership duration?
SELECT cd.Customer_ID, SUM(ct.Amount) AS Total_Spent,
ROUND(SUM(ct.Amount) / NULLIF(DATEDIFF(CURDATE(), MIN(cd.Membership_Since)) / 365, 0),2) AS CLV -- (CLV = Total Spend ​/ Years Active)
FROM Customer_Demographics cd
JOIN Customer_Transactions ct 
ON cd.Customer_ID = ct.Customer_ID
GROUP BY cd.Customer_ID;

-- 2. Customer Segmentation into value tiers based on CLV using quartile ranking. NTILE-CLV (Top 25%, etc.) --Who are our most valuable customers?
WITH CLV_Table AS (
SELECT cd.Customer_ID, SUM(ct.Amount) / NULLIF(DATEDIFF(CURDATE(), 
MIN(cd.Membership_Since))/ 365, 0) AS CLV -- CLV= TotalSpend/YearsActive
FROM Customer_Demographics cd
JOIN Customer_Transactions ct 
ON cd.Customer_ID = ct.Customer_ID
GROUP BY cd.Customer_ID)
SELECT *, NTILE(4) OVER (ORDER BY CLV DESC) AS CLV_Quartile -- ntile(win fun): dividing into 4 parts of 100 i.e. 25percent each--
FROM CLV_Table;


-- KPI: 3️. Churn Rate by Region: Which regions are losing customers fastest?
SELECT cd.Region, COUNT(DISTINCT cd.Customer_ID) AS Total_Customers,
SUM(CASE WHEN clc.`Churned (Yes/No)`= 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
ROUND(SUM(CASE WHEN clc.`Churned (Yes/No)`= 'Yes' THEN 1 ELSE 0 END)*100.0 /COUNT(DISTINCT cd.Customer_ID), 2) AS Churn_Rate -- (Churn Rate=Churned Customers/Total Customers*100)
FROM Customer_Demographics cd
JOIN Churn_Labelled_Customers clc 
ON cd.Customer_ID = clc.Customer_ID
GROUP BY cd.Region
ORDER BY Churn_Rate DESC;

-- 4. Repeat Purchase Segmentation: How loyal are our customers?
WITH Purchase_Count AS (
SELECT Customer_ID, COUNT(*) AS Purchase_Count
FROM Customer_Transactions
GROUP BY Customer_ID )
SELECT 
CASE 
WHEN Purchase_Count BETWEEN 2 AND 4 THEN 'Low Tier'
WHEN Purchase_Count BETWEEN 5 AND 10 THEN 'Mid Tier'
WHEN Purchase_Count >= 11 THEN 'High Tier'
ELSE 'One-Time'
END AS Purchase_Segment,
COUNT(*) AS Customer_Count
FROM Purchase_Count
GROUP BY Purchase_Segment;

-- 5. High-Value Customers at Risk-- Which valuable customers are at risk of churn?
SELECT cd.Customer_ID, SUM(ct.Amount) AS Total_Spent,
DATEDIFF(CURDATE(), MAX(ct.Transaction_Date)) AS Days_Since_Last_Purchase
FROM Customer_Demographics cd
JOIN Customer_Transactions ct 
ON cd.Customer_ID = ct.Customer_ID
GROUP BY cd.Customer_ID
HAVING SUM(ct.Amount) > (SELECT AVG(total_spend) 
FROM (
SELECT SUM(Amount) AS total_spend
FROM Customer_Transactions
GROUP BY Customer_ID
) t)
AND Days_Since_Last_Purchase > 90;

-- 6. Promotion Impact on Revenue-- Do promotions increase revenue or just reduce margins?
SELECT Promotion_Applied, COUNT(*) AS Transactions,
ROUND(AVG(Amount),2) AS Avg_Transaction_Value,
ROUND(SUM(Amount),2) AS Total_Revenue
FROM Customer_Transactions
GROUP BY Promotion_Applied;