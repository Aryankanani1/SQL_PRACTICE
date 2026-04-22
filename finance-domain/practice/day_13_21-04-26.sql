-- Q.62 Easy 
-- List all investment accounts with a balance over $100,000. 
-- Show customer_id, balance and opened_date.
USE sql_finance;
SELECT 
a.account_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
a.account_type,
a.balance
FROM accounts a 
JOIN customers c USING(customer_id)
WHERE a.account_type = 'investment' AND a.balance > 100000;

-- Q.63 Easy
-- What is the total amount of payments made to each merchant category? Join merchants and transactions.
SELECT 
m.merchant_id,
m.category,
SUM(t.amount) AS total_transaction
From merchants m 
JOIN transactions t USING(merchant_id) 
WHERE t.status = 'completed' AND t.transaction_type = 'payment' 
GROUP BY m.category, m.merchant_id
ORDER BY total_transaction DESC;

-- Q.64 Medium 
-- Using CTEs, find customers who made transactions in January 2024 
-- but NOT in February 2024 (churned customers).
WITH cte_jan_customers AS(
SELECT distinct
c.customer_id,
CONCAT(c.first_name, '_', c.last_name) AS full_name,
MONTHNAME(t.transaction_date) AS month_name
FROM customers c
JOIN accounts a USING(customer_id)
JOIN transactions t USING(account_id)
WHERE MONTH(t.transaction_date) = 1 AND YEAR(t.transaction_date) = 2024 AND t.status = 'completed'
), 
cte_feb_customers AS(
SELECT distinct
c.customer_id,
CONCAT(c.first_name, '_', c.last_name) AS full_name,
MONTHNAME(t.transaction_date) AS month_name
FROM customers c
JOIN accounts a USING(customer_id)
JOIN transactions t USING(account_id)
WHERE MONTH(t.transaction_date) = 2 AND YEAR(t.transaction_date) = 2024 AND t.status = 'completed'
)
SELECT 
CONCAT(c.first_name,'_',c.last_name) AS full_name,
c.email
FROM cte_jan_customers j
LEFT JOIN cte_feb_customers f USING(customer_id)
JOIN customers c USING(customer_id)
WHERE f.customer_id IS NULL;


-- Q.65 Medium 
-- Show the 3-transaction moving average of payment amounts per account. 
-- Show account_id, transaction_date, amount and 3-transaction moving average.
SELECT 
a.account_id,
t.transaction_date, 
t.amount,
AVG(t.amount) OVER(PARTITION BY account_id ORDER BY t.transaction_date 
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW ) AS '3-transaction_moving_average'
FROM accounts a
JOIN transactions t USING(account_id)
WHERE t.status = 'completed'  AND t.transaction_type = 'payment';

-- Q.66 Medium 
-- Find all customers who have made payments to MORE THAN 2 different merchant categories. 
-- Show customer name and category count.
SELECT 
c.customer_id, 
CONCAT(c.first_name,'_',c.last_name) AS full_name,
COUNT(DISTINCT m.category) AS total_category
FROM customers c 
JOIN accounts a USING(customer_id) 
JOIN transactions t USING(account_id) 
JOIN merchants m USING(merchant_id)
WHERE t.status = 'completed' AND t.transaction_type = 'payment'
GROUP BY customer_id
HAVING total_category > 2;
