-- Q.38 Medium 
-- Find accounts that have more than 3 payment transactions in the dataset. 
-- Show account_id, payment count and total payment amount.
USE sql_finance;
SELECT 
account_id,
COUNT(t.transaction_id) AS payment_count,
SUM(t.amount) AS total_payment_amount
FROM accounts a 
JOIN transactions t USING(account_id)
WHERE t.status = 'completed'
GROUP BY account_id
HAVING payment_count > 3
ORDER BY total_payment_amount DESC;

-- Q.39 Medium 
-- Using a CTE, find the month with the highest total transaction volume in 2024. 
-- Show month, total amount and transaction count.
WITH cte_highest_transaction_volum AS
(SELECT 
MONTH(t.transaction_date) AS transaction_month,
SUM(t.amount) AS total_amount,
COUNT(t.transaction_id) AS transaction_count
FROM transactions t
WHERE t.status = 'completed' AND YEAR(t.transaction_date) = '2024'
GROUP BY MONTH(t.transaction_date)
ORDER BY total_amount DESC
)
SELECT
*
FROM cte_highest_transaction_volum 
LIMIT 1;


-- Q.40 Medium 
-- Find all loans where the interest rate is above the average interest rate for that loan type. 
-- Show loan_id, loan_type, rate and average rate for that type.

SELECT 
loan_id,
loan_type,
interest_rate
FROM loans l
WHERE interest_rate > (SELECT 
ROUND(AVG(interest_rate),2) AS avg_interest_rate
FROM loans 
WHERE loan_type = l.loan_type);

-- Q.41 Medium 
-- For each merchant category, rank the merchants by total payment received. 
-- Show category, merchant name, total received and rank within category.
WITH cte_rank_merchat_categories AS(SELECT 
merchant_id,
name AS merchant_name,
category,
SUM(t.amount) AS total_transaction
FROM merchants 
JOIN transactions t USING(merchant_id)
GROUP BY merchant_id)
SELECT 
RANK() OVER(PARTITION BY category ORDER BY total_transaction DESC),
merchant_name,
category,
total_transaction
FROM cte_rank_merchat_categories;

-- Q.42 Medium 
-- Find customers who have loans in more than one loan type (e.g., both mortgage AND personal). 
-- Show customer name and list of loan types.
SELECT 
customer_id,
CONCAT(c.first_name, '_',c.last_name) AS full_name,
COUNT(loan_type) AS loan_type
FROM customers c
JOIN loans USING(customer_id)
WHERE status = 'active' 
GROUP BY customer_id
HAVING loan_type > 1;
