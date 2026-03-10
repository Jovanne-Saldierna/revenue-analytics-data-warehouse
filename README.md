# Revenue Analytics Data Mart

Senior-level SQL and Tableau project demonstrating how transactional order data can be transformed into a reporting-ready analytics layer for executive revenue reporting, customer retention analysis, and product performance measurement.

## Project Summary

This project simulates the design of a revenue-focused analytics data mart that supports recurring business review and executive KPI reporting. Using raw order, customer, and product data, I built SQL transformation logic to define standardized revenue metrics, customer cohort retention, customer lifetime value, and product-level performance.

The resulting models are structured to support scalable BI reporting and Tableau dashboard development.

## Analytics Architecture

This project follows a layered analytics modeling approach commonly used in modern BI environments.

Raw Source Data (CSV tables)  
→ SQL Staging Layer  
→ Business Metric Models  
→ Executive KPI Summary Table  
→ Tableau Executive Dashboard

The SQL models define standardized revenue metrics, retention analysis, product performance, and customer lifetime value used for executive reporting.
## Business Questions Answered

- How is revenue trending month over month?
- What is driving revenue growth or decline?
- How many new versus returning customers are purchasing each month?
- Which products generate the highest revenue and order volume?
- How are customer cohorts retained over time?
- Which customers generate the highest lifetime value?

 ## Key Insights from the Analysis

Using the modeled metrics, several actionable business insights emerge:

- Revenue growth is primarily driven by repeat customers rather than new customer acquisition.
- A small subset of products contributes a disproportionate share of total revenue, suggesting opportunities for focused marketing and inventory planning.
- Paid Search drives strong initial acquisition but lower long-term retention compared to Organic and Referral channels.
- High-value customers demonstrate significantly higher order frequency and lifetime value, indicating potential for loyalty or subscription programs.

## Technical Skills Demonstrated

- Advanced SQL transformations
- Common Table Expressions (CTEs)
- Window functions
- Cohort retention analysis
- Customer lifetime value modeling
- KPI standardization
- Tableau dashboard design
- Reporting layer development

## Analytics Flow

Raw CSV Source Data  
→ SQL Staging and Metric Modeling  
→ Reporting-Ready Revenue Data Mart  
→ Tableau Executive Dashboard
