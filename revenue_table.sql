-- DATA CLEANING - REVENUE TABLE
select *
from revenue;

CREATE TABLE revenue_staging
LIKE revenue;

INSERT INTO revenue_staging
SELECT *
FROM revenue;

SELECT *
from revenue_staging;

-- Duplicate
SELECT subscription_id, COUNT(*)
FROM revenue_staging
GROUP BY subscription_id
HAVING COUNT(*) > 1;
#There is no duplicate

SELECT subscription_id, month, COUNT(*)
FROM revenue_staging
GROUP BY subscription_id, month
HAVING COUNT(*) > 1;

-- Missing Values
SELECT COUNT(*) FROM revenue_staging WHERE subscription_id IS NULL OR subscription_id = "";
SELECT COUNT(*) FROM revenue_staging WHERE customer_id IS NULL OR customer_id = "";
SELECT COUNT(*) FROM revenue_staging WHERE month IS NULL OR month = "";
SELECT COUNT(*) FROM revenue_staging WHERE monthly_fee IS NULL OR monthly_fee = "";
SELECT COUNT(*) FROM revenue_staging WHERE revenue_type IS NULL OR revenue_type = "";
SELECT COUNT(*) FROM revenue_staging WHERE amount IS NULL OR amount = "";

-- Distinct Values
SELECT DISTINCT monthly_fee FROM revenue_staging;
SELECT DISTINCT revenue_type FROM revenue_staging;
SELECT DISTINCT amount FROM revenue_staging;

-- Data Format
ALTER TABLE revenue_staging
ADD COLUMN month_date DATE;

UPDATE revenue_staging
SET month_date = STR_TO_DATE(CONCAT(month, '-01'), '%Y-%m-%d');

-- Logic Controls
SELECT *
FROM revenue_staging
WHERE amount < 0;

SELECT *
FROM revenue_staging
WHERE amount < monthly_fee;

-- EDA
# 1.Total Revenue
SELECT SUM(amount) AS total_revenue
FROM revenue_staging;
#Total_revenue: 249800

# 2. MRR Trend
SELECT 
	DATE_FORMAT(month_date, '%Y-%m') AS month_,
    SUM(amount) AS monthly_revenue
FROM revenue_staging
GROUP BY month_
ORDER BY month_;

# 3. Top Customer Revenue
SELECT 
    customer_id,
    SUM(amount) AS total_revenue
FROM revenue_staging
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 10;

-- ANALYSIS
#MRR(Monthly Recurring Revenue):
SELECT 
    DATE_FORMAT(month_date, '%Y-%m') AS month_,
    SUM(amount) AS MRR
FROM revenue_staging
WHERE revenue_type = 'MRR'
GROUP BY month_
ORDER BY month_;

#ARR(Annual Recurring Revenue):
SELECT SUM(amount) * 12 AS ARR
FROM revenue_staging;
#ARR: 2997600

#ARPU(Average Revenue Per User):
SELECT 
    ROUND(SUM(amount) / COUNT(DISTINCT customer_id),2) AS ARPU
FROM revenue_staging;
#ARPU: 1486.90

#Revenue Plan: Which plan makes more money?
SELECT 
    c.plan_type,
    SUM(r.amount) AS total_revenue
FROM revenue_staging r
JOIN customers_staging c 
ON r.customer_id = c.customer_id
GROUP BY c.plan_type
ORDER BY total_revenue;
#Basic: 16000, Pro: 66800, Enterprise: 167000

# Revenue Distribution
SELECT 
    c.plan_type,
    ROUND(SUM(r.amount) / (SELECT SUM(amount) FROM revenue_staging) * 100, 2) AS revenue_percentage
FROM revenue_staging r
JOIN customers_staging c 
ON r.customer_id = c.customer_id
GROUP BY c.plan_type
ORDER BY revenue_percentage;
#Basic: %6.41, Pro: %26.72, Enterprise: %66.85




SELECT *
from revenue_staging;

