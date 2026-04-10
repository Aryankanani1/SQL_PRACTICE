-- Q.19Easy 
-- What is the total balance across all active checking accounts? 
-- What is the average balance?
SELECT 
SUM(balance) AS total_balance,
ROUND(AVG(balance),2) AS average_balance 
FROM accounts 
WHERE account_type = 'checking' AND status = 'active';

-- Q.20Easy 
-- What is the total transaction amount processed in January 2024? 
-- How many transactions were there?
SELECT 
SUM(amount) AS total_transaction,
COUNT(transaction_id) AS total_transaction_count
FROM transactions 
WHERE YEAR(transaction_date) = 2024 AND MONTH(transaction_date) = 1 AND 
status = 'completed';

-- Q.21 Easy 
-- What is the total outstanding loan balance across all active loans?
-- Break it down by loan type.
SELECT 
loan_type,
SUM(outstanding_balance) AS total_balance
FROM loans 
WHERE status = 'active'
GROUP BY loan_type;

-- Q.22 Medium 
-- Using a CTE, calculate each customer's total debt (sum of all outstanding loan balances). 
-- Then show only customers whose total debt exceeds their total account balance.
WITH cte_total_debt_par_customers AS (
SELECT
customer_id, 
SUM(outstanding_balance) AS total_debt
FROM loans 
JOIN customers USING(customer_id)
WHERE status = 'active'
GROUP BY customer_id
), cte_total_balance_per_customers AS(
SELECT 
customer_id,
SUM(balance) AS total_balance
FROM accounts
WHERE status = 'active'
GROUP BY customer_id
)
SELECT 
customer_id,
CONCAT(first_name ,'_' , last_name) AS full_name
FROM customers 
JOIN cte_total_debt_par_customers USING(customer_id)
JOIN cte_total_balance_per_customers USING(customer_id)
WHERE total_debt > total_balance;

-- Q.23 Medium 
-- Using a CTE, find the top 3 accounts by total transaction volume in January 2024. 
-- Show account_id, customer name and total volume. 
WITH cte_total_transaction_volum AS(
SELECT 
a.account_id,
COUNT(t.transaction_id) AS total_transaction,
SUM(t.amount) AS total_volume
FROM transactions t 
JOIN accounts a USING(account_id)
WHERE t.status = 'completed' 
	AND YEAR(transaction_date) = 2024 
	AND MONTH(transaction_date) = 1
GROUP BY a.account_id
)
SELECT
account_id, 
CONCAT(c.first_name ,'_',c.last_name) AS full_name,
total_transaction,
total_volume
FROM customers c 
JOIN accounts a USING(customer_id)
JOIN cte_total_transaction_volum USING(account_id)
ORDER BY total_volume DESC
LIMIT 3;
