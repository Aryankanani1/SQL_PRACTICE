-- Q.13 Easy 
-- Show all transactions made at Amazon (merchant_id = 1). 
-- Show transaction_id, account_id, amount, and transaction_date.
USE sql_finance;
SELECT 
transaction_id,
account_id,
amount,
transaction_date
FROM transactions 
WHERE merchant_id = 1
ORDER BY amount DESC;

-- Q.14 Easy
-- Find all accounts that are currently frozen or closed. 
-- Show account_id, customer_id, account_type and status.
SELECT 
account_id,
customer_id,
account_type,
status AS account_status
FROM accounts 
WHERE status in ('active','frozen')
ORDER BY status DESC;

-- Q.15 Easy 
-- List all customers from California (CA) or Texas (TX). 
-- Show full name, city, state and email.
SELECT 
customer_id,
CONCAT(first_name,'_',last_name) AS full_name,
city,
state,
email
FROM customers 
WHERE state IN ('CA','TX')
ORDER BY customer_id;

-- Q.16 Medium
-- For each transaction, show the previous transaction amount on the same account and the percentage change. 
-- Show account_id, date, amount, previous amount and pct change.
WITH cte_previous_transaction AS (SELECT 
transaction_id,
account_id,
transaction_date,
amount,
LAG(amount) OVER(PARTITION BY account_id ORDER BY transaction_date) AS previous_transaction
FROM transactions
WHERE status = 'completed'
ORDER BY account_id)
SELECT 
*,
ROUND((amount - previous_transaction) / NULLIF(previous_transaction,0) * 100 ,2) precentage_change
FROM cte_previous_transaction;


-- Q.17 Medium 
-- Rank all customers by their total account balance. Show rank, customer name and total balance. 
-- Use DENSE_RANK so tied balances get the same rank.
WITH cte_total_balance AS(SELECT
c.customer_id,
CONCAT(first_name, '_', last_name) AS full_name,
SUM(balance) AS total_balance
FROM customers c
JOIN accounts a USING(customer_id)
WHERE a.status = 'active'
GROUP BY c.customer_id, c.first_name, c.last_name)
SELECT 
DENSE_RANK() OVER(ORDER BY total_balance DESC) AS wealth_rank,
customer_id,
full_name,
total_balance
FROM cte_total_balance;

-- Q.18 Hard 
-- Build a loan amortization summary: for each loan show original principal, 
-- total paid to date, total interest paid, total principal paid, remaining balance, and percentage paid off. 
-- Sort by pct paid off.
WITH cte_amortization_summary AS(
SELECT 
lp.loan_id,
SUM(lp.interest_paid) AS total_interest_paid,
SUM(lp.principal_paid) AS total_principal_paid,
SUM(lp.amount_paid) AS total_paid_to_date
FROM loan_payments lp 
GROUP BY lp.loan_id
)
SELECT 
l.loan_id,
l.loan_type,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
l.principal_amount,
ps.total_interest_paid,
ps.total_principal_paid,
ps.total_paid_to_date,
ROUND(ps.total_principal_paid / l.principal_amount * 100,2) AS total_interest_paid_off,
ROUND(ps.total_interest_paid / ps.total_paid_to_date * 100,2) AS interest_paid
FROM loans l
JOIN cte_amortization_summary ps USING(loan_id)
JOIN customers c USING(customer_id)
ORDER BY total_interest_paid_off DESC;
