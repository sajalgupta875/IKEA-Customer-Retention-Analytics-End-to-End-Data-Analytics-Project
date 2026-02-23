# IKEA-Customer-Retention-Analytics-End-to-End-Data-Analytics-Project
End-to-end IKEA Customer Retention Analytics project using MySQL and Power BI. Includes CLV modeling, churn analysis, repeat purchase segmentation, promotion impact evaluation, income group revenue analysis, and cohort retention tracking. Designed to generate actionable insights for improving customer retention and business strategy.

This project presents a comprehensive end-to-end customer retention analytics solution developed for IKEA, focusing on understanding customer behavior, churn patterns, lifetime value, and promotional impact. The objective was to transform raw transactional and demographic data into actionable business insights using MySQL and Power BI.

The project begins with structured data modeling and transformation using Power Query, followed by advanced SQL-based KPI computation. Key metrics such as Customer Lifetime Value (CLV), Churn Rate, Repeat Purchase Segmentation, Revenue by Income Group, and Cohort Retention Analysis were calculated to evaluate customer profitability and retention dynamics. CLV was normalized by membership tenure to identify truly high-value customers rather than relying solely on total spend.

Using MySQL, advanced queries were written to perform segmentation using NTILE quartile ranking, detect high-value customers at risk (high spend but inactive for 90+ days), and analyze churn distribution across regions and income groups. Promotion effectiveness was evaluated by comparing average transaction value and total revenue under promotional versus non-promotional transactions.

A multi-page Power BI dashboard was built to visualize insights across four strategic layers:
Overview KPIs (CLV, Churn, Repeat Rate)
Loyalty & Promotion Impact
Store & Regional Performance
Customer Segmentation & Risk Identification

Cohort retention analysis was implemented to track how customer groups behave over time after acquisition, providing deeper visibility into long-term retention trends.

Key Insights:
The top 25% of customers contribute a disproportionate share of revenue.
Certain regions exhibit significantly higher churn rates.
Promotions increase transaction value but do not substantially reduce churn.
A segment of high-value customers shows inactivity risk, indicating opportunity for targeted retention campaigns.

This project demonstrates practical skills in data cleaning, SQL analytics, window functions, KPI modeling, business interpretation, and executive-level dashboard communication. It reflects a real-world data analytics workflow from raw data to strategic insight generation

🔎 Business Insights:
1. Revenue Concentration-
The top 25% of customers (CLV-based segmentation) contribute a disproportionately high share of total revenue. Customer value distribution is highly skewed.

2. Regional Churn Variance-
Certain regions exhibit significantly higher churn rates compared to others, indicating localized service, pricing, or competition issues.

3. High-Value Customers at Risk-
A segment of high-CLV customers shows inactivity beyond 90 days, representing a direct revenue risk.

4. Promotion Impact-
Promotions increase average transaction value but do not significantly reduce churn. Discount-driven sales may not translate into long-term loyalty.

5. Repeat Purchase Distribution-
A large portion of customers fall into low purchase-frequency tiers, while a smaller high-frequency segment drives repeat revenue.

6. Income Group Revenue Behavior-
Higher-income groups generate greater revenue per customer, but mid-income segments represent a large volume opportunity.

7. Cohort Retention Trend-
Customer retention declines sharply after initial purchase months, highlighting early lifecycle drop-off.

🎯 Strategic Recommendations:
1. Prioritize High-CLV Retention
Implement targeted loyalty rewards and personalized communication for top quartile customers to prevent churn.

2. Early Lifecycle Engagement-
Improve onboarding and first 60-day engagement strategies to reduce early drop-offs observed in cohort analysis.

3. Regional Strategy Optimization-
Conduct region-specific diagnostics and localized marketing campaigns in high-churn markets.

4. Smart Promotion Targeting-
Shift from blanket promotions to data-driven targeted offers aimed at at-risk and mid-tier customers.

5. Upsell Mid-Tier Customers-
Focus on converting mid-frequency buyers into high-tier customers via cross-selling and loyalty incentives.

6. Monitor High-Value Inactivity-
Deploy automated alerts for high-CLV customers inactive beyond 60–90 days.
