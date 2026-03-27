# SaaS Analytics Project

## Executive Summary  
This project analyzes a SaaS (Software as a Service) business dataset to evaluate customer behavior, subscription lifecycle, and revenue performance.

Using customer, subscription, and revenue data, the analysis explores user retention, churn patterns, revenue growth, and key SaaS metrics such as MRR, ARR, ARPU, and CLTV.

---

## Business Problem
- What is the retention and churn rate of customers?  
- Which subscription plans generate the most revenue?  
- How does user behavior change over time?  
- Is the business growing in terms of subscriptions and revenue?  
- Which customer segments are the most valuable?  
- How efficient is customer acquisition compared to revenue generated?  

---

## Methodology  

### Data Cleaning & Preparation (MySQL)  
- Created staging tables to preserve raw data  
- Removed duplicate records  
- Handled missing and blank values  
- Standardized categorical variables  
- Converted date fields into proper formats  
- Validated data consistency and logic checks  

---

### Exploratory Data Analysis (MySQL)  
- Active vs churned user distribution  
- Subscription trends over time  
- Revenue trends (monthly)  
- Plan distribution and usage  
- Customer acquisition cost analysis  
- Average subscription fee analysis  

---

### Business Analysis (MySQL)  

#### Customer Analysis  
- Retention rate calculation  
- Churn rate analysis  
- Customer lifetime (duration analysis)  
- Acquisition cost vs churn relationship  

#### Revenue Analysis  
- Total revenue calculation  
- MRR (Monthly Recurring Revenue)  
- ARR (Annual Recurring Revenue)  
- ARPU (Average Revenue Per User)  
- CLTV (Customer Lifetime Value)  
- Revenue by subscription plan  

#### Subscription Analysis  
- Monthly active subscriptions  
- Subscription growth rate (MoM growth)  
- Average subscription duration  
- Renewal behavior analysis  

#### Cohort Analysis  
- User grouping based on signup month  
- Tracking user activity over time  
- Retention behavior across cohorts  

---

## Skills 
- SQL (MySQL) -> GROUP BY, JOINs, Window Functions (LAG), Aggregations, Date Functions 

- Product Analytics  
- SaaS Metrics (MRR, ARR, ARPU, CLTV)  
- Retention & Churn Analysis  
- Cohort Analysis  

---

## Results & Insights  
- Retention rate is high (~83%), but churn (~17%) is still significant  
- User distribution across plans is balanced, with no dominant segment  
- Enterprise plan generates the highest revenue despite fewer users  
- Acquisition cost does not significantly impact retention  
- Basic plan users show the highest churn rate  
- Revenue is highly dependent on high-value (Enterprise) customers
- Subscription growth fluctuates over time, indicating inconsistent growth patterns  
- Cohort analysis shows declining user retention over time  

---

## Business Recommendations  
- Improve onboarding experience for Basic plan users to reduce churn  
- Implement upsell strategies to move users from Basic to Pro plans  
- Optimize acquisition channels to reduce cost inefficiencies  
- Focus on retaining high-value Enterprise customers  
- Develop retention strategies such as email engagement and personalized offers  
- Monitor churn patterns and build early warning systems  
- Introduce loyalty programs for long-term users  

---

## Next Steps  
- Build a machine learning model for churn prediction  
- Implement A/B testing for pricing and onboarding improvements  
