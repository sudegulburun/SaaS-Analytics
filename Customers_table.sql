-- DATA CLEANING - Customers table

SELECT *
FROM customers;

CREATE TABLE customers_staging
LIKE customers;

INSERT INTO customers_staging
SELECT *
FROM customers;

SELECT *
FROM customers_staging;

-- Duplicate
SELECT customer_id, COUNT(*)
FROM customers_staging
GROUP BY customer_id
HAVING COUNT(*) > 1;
#There is no duplicate

-- Missing Values
SELECT COUNT(*) FROM customers_staging WHERE customer_id IS NULL OR customer_id = "";
SELECT COUNT(*) FROM customers_staging WHERE signup_date IS NULL OR signup_date = "";
SELECT COUNT(*) FROM customers_staging WHERE plan_type IS NULL OR plan_type = "";
SELECT COUNT(*) FROM customers_staging WHERE monthly_fee IS NULL OR monthly_fee = "";
SELECT COUNT(*) FROM customers_staging WHERE acquisition_cost IS NULL OR acquisition_cost = "";
SELECT COUNT(*) FROM customers_staging WHERE churn_date IS NULL OR churn_date = "";
#There are 832 blank values in the churn_date feature, it means they are active 

-- Data type formats
UPDATE customers_staging
SET churn_date = NULL
WHERE churn_date = '';

ALTER TABLE customers_staging
MODIFY COLUMN signup_date DATE,
MODIFY COLUMN churn_date DATE;

-- Distinct Values
SELECT DISTINCT plan_type FROM customers_staging;
SELECT DISTINCT monthly_fee FROM customers_staging;
SELECT DISTINCT acquisition_cost FROM customers_staging;
SELECT DISTINCT signup_date FROM customers_staging;

-- Logic Controls
SELECT COUNT(*)
FROM customers_staging
WHERE monthly_fee < 0;

SELECT COUNT(*)
FROM customers_staging
WHERE churn_date < signup_date;

-- churn_date column adjusting
ALTER TABLE customers_staging 
ADD COLUMN customer_status VARCHAR(10);

UPDATE customers_staging
SET customer_status = CASE 
    WHEN churn_date IS NULL THEN 'Active'
    ELSE 'Churned'
END;


-- EDA 
#Business Problem1: How many active / churn users are there?
SELECT customer_status, COUNT(*) AS user_count
FROM customers_staging
GROUP BY customer_status;
#Active: 832, Churned: 168

#Business Problem2: Which plan is used more often?
SELECT plan_type, COUNT(*) AS user_count
FROM customers_staging
GROUP BY plan_type
ORDER BY user_count DESC;
#Pro: 343, Enterprise: 330, Basic: 327

#Business Problem3: Is user acquisition expensive?
SELECT plan_type, AVG(acquisition_cost) AS avg_acquisition_cost
FROM customers_staging
GROUP BY plan_type
ORDER BY avg_acquisition_cost DESC;
#Enterprise: 200, Pro: 100, Basic: 30

#Business Problem3: How long does the user stay?
SELECT 
    customer_id,
    DATEDIFF(churn_date, signup_date) AS lifetime_days
FROM customers_staging
WHERE churn_date IS NOT NULL
ORDER BY lifetime_days DESC
LIMIT 10;

-- ANALYSIS
# 1.Retention Analysis: It measures how long users stay in the system
#Business Problem: Are we able to retain users?

SELECT 
    COUNT(*) AS total_users,
    SUM(CASE WHEN churn_date IS NULL THEN 1 ELSE 0 END) AS active_users,
    ROUND(SUM(CASE WHEN churn_date IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS retention_rate
FROM customers_staging;
#total_users: 1000, active_users: 832, retention_rate: 83.20

# 1.Churn Analysis: It measures how many users were lost
#Business Problem: Why are users leaving?

SELECT 
    COUNT(*) AS total_users,
    SUM(CASE WHEN churn_date IS NOT NULL THEN 1 ELSE 0 END) AS churned_users,
    ROUND(SUM(CASE WHEN churn_date IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate
FROM customers_staging;
#total: 1000, churned: 168, churn_rate: 16.80

#Acquisition Cost vs Churn
SELECT customer_status, ROUND(AVG(acquisition_cost), 2) AS avg_cost
FROM customers_staging
GROUP BY customer_status;
#Active: 110.18 , Churned: 109.76

#Plan Type vs Churn
SELECT plan_type,
    COUNT(*) AS total_users,
    SUM(CASE WHEN churn_date IS NOT NULL THEN 1 ELSE 0 END) AS churned_users,
    ROUND(SUM(CASE WHEN churn_date IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate
FROM customers_staging
GROUP BY plan_type
ORDER BY churn_rate DESC;
#Basic: 17.74, Enterprise: 17.27, Pro: 15.45

#Customer Lifetime Value
SELECT 
    customer_id,
    monthly_fee * DATEDIFF(churn_date, signup_date) AS lifetime_value
FROM customers_staging
WHERE churn_date IS NOT NULL
ORDER BY lifetime_value DESC
LIMIT 10;



SELECT *
FROM customers_staging;
