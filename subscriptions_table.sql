-- DATA CLEANING - SUBSCRIPTIONS TABLE
select *
from subscriptions;

CREATE TABLE subscriptions_staging
LIKE subscriptions;

INSERT INTO subscriptions_staging
SELECT *
FROM subscriptions;

SELECT *
FROM subscriptions_staging;

-- Duplicate
SELECT subscription_id, COUNT(*)
FROM subscriptions_staging
GROUP BY subscription_id
HAVING COUNT(*) > 1;

SELECT subscription_id, month, COUNT(*)
FROM subscriptions_staging
GROUP BY subscription_id, month
HAVING COUNT(*) > 1;

-- Missing Values
SELECT COUNT(*) FROM subscriptions_staging WHERE subscription_id IS NULL OR subscription_id = "";
SELECT COUNT(*) FROM subscriptions_staging WHERE customer_id IS NULL OR customer_id = "";
SELECT COUNT(*) FROM subscriptions_staging WHERE month IS NULL OR month = "";
SELECT COUNT(*) FROM subscriptions_staging WHERE monthly_fee IS NULL OR monthly_fee = "";

-- Distinct Values
SELECT DISTINCT customer_id FROM subscriptions_staging;
SELECT DISTINCT month FROM subscriptions_staging;
SELECT MAX(month), MIN(month) FROM subscriptions_staging;
SELECT DISTINCT monthly_fee FROM subscriptions_staging;

-- Data Format
ALTER TABLE subscriptions_staging
ADD COLUMN month_date DATE;

UPDATE subscriptions_staging
SET month_date = STR_TO_DATE(CONCAT(month, '-01'), '%Y-%m-%d');

-- Logic Controls
SELECT *
FROM subscriptions_staging
WHERE monthly_fee < 0;

-- EDA
#Subscription Record:
SELECT COUNT(*) FROM subscriptions_staging;
#record: 988

#Total Customers:
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM subscriptions_staging;
#total_customers: 168

#Monthly active subscriptions:
SELECT 
	DATE_FORMAT(month_date, '%Y-%m') AS month_,
    COUNT(DISTINCT subscription_id) AS active_subscriptions
FROM subscriptions_staging
GROUP BY month_date
ORDER BY month_date;

#Average Wage:
SELECT ROUND(AVG(monthly_fee),2) AS avg_fee
FROM subscriptions_staging;
#avg_fee: 252.83

#Number of subscriptions per user:
SELECT 
	customer_id,
	COUNT(DISTINCT subscription_id) AS subscription_count
FROM subscriptions_staging
GROUP BY customer_id
ORDER BY subscription_count DESC;

#High Value Users:
SELECT 
    customer_id,
    SUM(monthly_fee) AS total_value
FROM subscriptions_staging
GROUP BY customer_id
ORDER BY total_value DESC
LIMIT 10;

-- ANALYSIS
#MRR(Monthly Recurring Revenue - Based on Subscriptions)
SELECT 
    DATE_FORMAT(month_date, '%Y-%m') AS month_,
    SUM(monthly_fee) AS MRR
FROM subscriptions_staging
GROUP BY month_
ORDER BY month_;

#Renewal Rate: Are users continuing their subscription?
SELECT 
    COUNT(DISTINCT customer_id) AS total_users,
    COUNT(DISTINCT CASE WHEN active_months > 1 THEN customer_id END) AS renewed_users
FROM (
    SELECT 
        customer_id,
        COUNT(DISTINCT month_date) AS active_months
    FROM subscriptions_staging
    GROUP BY customer_id
) t;
#total: 168, renewed: 156

#Average Subscription Duration:
SELECT 
    customer_id,
    COUNT(DISTINCT month_date) AS active_months
FROM subscriptions_staging
GROUP BY customer_id
ORDER BY active_months DESC;

#Growth Rate (Subscription Growth):
SELECT 
    month_,
    active_subscriptions,
    LAG(active_subscriptions) OVER (ORDER BY month_) AS prev_month,
    ROUND((active_subscriptions - LAG(active_subscriptions) OVER (ORDER BY month_)) 
          / LAG(active_subscriptions) OVER (ORDER BY month_) * 100, 2) AS growth_rate
FROM (
    SELECT 
        DATE_FORMAT(month_date, '%Y-%m') AS month_,
        COUNT(DISTINCT subscription_id) AS active_subscriptions
    FROM subscriptions_staging
    GROUP BY month_
) t;


#Revenue:
SELECT 
    DATE_FORMAT(month_date, '%Y-%m') AS month_,
    SUM(monthly_fee) AS revenue
FROM subscriptions_staging
GROUP BY month_
ORDER BY month_;

#Customer-Subscription Join
SELECT 
    c.plan_type,
    COUNT(DISTINCT s.subscription_id) AS subscriptions,
    SUM(s.monthly_fee) AS revenue
FROM subscriptions_staging s
JOIN customers_staging c 
ON s.customer_id = c.customer_id
GROUP BY c.plan_type;

#Cohort: Group them according to the month they registered
SELECT 
    DATE_FORMAT(c.signup_date, '%Y-%m') AS cohort,
    COUNT(DISTINCT s.customer_id) as user_count
FROM subscriptions_staging s
JOIN customers_staging c 
ON s.customer_id = c.customer_id
GROUP BY cohort;

#Cohort2: Are users who joined in the same month still active in subsequent months?
SELECT 
    DATE_FORMAT(c.signup_date, '%Y-%m') AS cohort,
    DATE_FORMAT(s.month_date, '%Y-%m') AS activity_month,
    COUNT(DISTINCT s.customer_id) AS users
FROM subscriptions_staging s
JOIN customers_staging c 
ON s.customer_id = c.customer_id
GROUP BY cohort, activity_month
ORDER BY cohort, activity_month;

SELECT *
FROM subscriptions_staging;





