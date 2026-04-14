-- Q.33 Easy
-- Count the total number of transactions by transaction type. 
-- Show type, count and total amount.
Use sql_finance;
SELECT 
transaction_type,
COUNT(transaction_id) AS total_transaction,
SUM(amount) AS total_amount
FROM transactions t 
GROUP BY transaction_type;

-- Q.34 Easy 
-- How many accounts does each customer have? Show customer_id and account count. 
-- Only show customers with more than 1 account.
SELECT 
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
COUNT(account_id) AS total_accounts
FROM customers c
JOIN accounts a USING(customer_id) 
GROUP BY customer_id
HAVING total_accounts > 1
ORDER BY total_accounts DESC;

-- Q.35 Easy 
-- What is the total amount spent per merchant? Show merchant_id, count of transactions and total amount. 
-- Only include completed transactions.
SELECT 
merchant_id,
name AS merchant_name,
COUNT(*) AS total_transactions,
SUM(t.amount) AS total_amount
FROM merchants m 
JOIN transactions t USING(merchant_id)
WHERE t.status = 'completed'
GROUP BY merchant_id
ORDER BY total_amount DESC;

-- Q.36 Medium 
-- Find all customers whose total account balance is above the average total balance of all customers. 
-- Show customer name and their total balance.
SELECT 
c.customer_id,
CONCAT(c.first_name ,'_', c.last_name) AS full_name,
ROUND(SUM(a.balance),2) AS total_balance
FROM customers c 
JOIN accounts a USING(customer_id)
WHERE a.status = 'active'
GROUP BY c.customer_id
HAVING total_balance > 
(SELECT 
AVG(total_ac_balance) AS avg_total_balance
FROM (
SELECT
customer_id,
SUM(balance) AS total_ac_balance
FROM accounts 
WHERE a.status = 'active'
GROUP BY customer_id
) CT
)
ORDER BY total_balance DESC;

-- Q.37 Medium 
-- Find all accounts that have never had any transaction. 
-- Show account_id, account_type, balance and opened_date.
SELECT 
DISTINCT 
a.account_id,
a.account_type,
a.balance,
a.opened_date
FROM accounts a
WHERE account_id NOT IN (
SELECT 
a.account_id
FROM accounts a 
JOIN transactions t USING(account_id)
WHERE t.status = 'completed')
