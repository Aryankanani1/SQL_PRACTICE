-- Q.1 Easy 
-- List all customers who joined the bank in the year 2020.
-- Show their full name, email, and the date they joined.
SELECT 
customer_id,
CONCAT(first_name, '_', last_name) AS full_name,
email,
created_at 
FROM customers
WHERE year(created_at) = 2020
ORDER BY created_at;

-- Q.2 Easy 
-- Find all accounts with a balance greater than $10,000. 
-- Show account_id, account_type, balance and status. Sort by balance descending.
USE sql_finance;
SELECT 
	account_id,
	account_type,
	balance,
	status AS account_status
FROM accounts    
WHERE balance > 10000
ORDER BY balance DESC;

-- Q.3 Easy 
-- Show all transactions that have a status of "failed" or "reversed". 
-- Show transaction_id, amount, transaction_date and status.
SELECT 
	transaction_id,
    amount,
    transaction_date,
    status AS transaction_status
FROM transactions 
WHERE status IN ('failed','reversed')
ORDER BY transaction_date DESC;  

-- Q.4 Medium 
-- Find customers whose total transaction amount (all accounts combined) exceeds $10,000 in January 2024.
-- Show customer name and total amount.
SELECT 
a.account_id,
CONCAT(first_name,'_',last_name) AS full_name,
SUM(t.amount) AS total_transaction
FROM transactions t 
JOIN accounts a USING(account_id)
JOIN customers c USING(customer_id)
WHERE t.status = 'completed' 
		AND YEAR(t.transaction_date) = 2024
GROUP BY a.account_id
HAVING total_transaction > 10000;

-- Q.5 Medium 
-- Which merchants received more than $200 in total payments? 
-- Show merchant name, category, transaction count and total received.
SELECT 
m.merchant_id,
m.name AS merchant_name,
m.category,
COUNT(t.transaction_id) AS transaction_count,
SUM(t.amount) AS total_payments
FROM merchants m 
JOIN transactions t USING(merchant_id) 
WHERE t.status = 'completed'
GROUP BY merchant_id 
HAVING total_payments > 200
ORDER BY total_payments DESC;

-- Q.6 Hard 
-- For each customer, find their "peak spending month" - the month where they spent the most. 
-- Show customer name, peak month and peak amount.
WITH cte_monthly_totals AS (
SELECT 
c.customer_id,
CONCAT(first_name ,'_', last_name) AS full_name,
SUM(t.amount) AS total_spending,
MONTHNAME(t.transaction_date) AS peak_month
FROM transactions t 
JOIN accounts a USING(account_id)
JOIN customers c USING(customer_id)
WHERE t.status = 'completed'
	AND t.transaction_type = 'payment'
GROUP BY c.customer_id, c.first_name, c.last_name,MONTHNAME(t.transaction_date) 
) , ranked AS
(
SELECT 
*,
ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY total_spending DESC) AS peak_spending_rank
FROM cte_monthly_totals
)

SELECT 
customer_id, 
full_name,
total_spending,
peak_month
FROM ranked
WHERE peak_spending_rank = 1
ORDER BY total_spending DESC
