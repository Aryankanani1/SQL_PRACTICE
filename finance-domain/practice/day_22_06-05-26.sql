-- Q.101
-- Using a CTE, calculate the monthly interest income for the bank. For each month show:
-- month, total_payments, total_principal_collected and total_interest_income.
USE sql_finance;
SELECT
MONTHNAME(lp.payment_date),
COUNT(*) total_payments,
SUM(lp.amount_paid) AS total_amount_paid,
SUM(lp.interest_paid) AS total_interest_paid,
SUM(lp.principal_paid) AS total_interest_income
FROM loan_payments lp
GROUP BY MONTH(lp.payment_date), MONTHNAME(lp.payment_date), YEAR(lp.payment_date);

-- Q.102
-- Show the top 2 transactions by amount for each account.
-- Show account_id, transaction_id, amount, type and rank.
SELECT
*
FROM (
	SELECT
	a.account_id,
	t.transaction_id,
	t.amount,
	t.transaction_type,
	ROW_NUMBER() OVER(PARTITION BY a.account_id ORDER BY t.amount DESC) AS transaction_rank
	FROM accounts a
	JOIN transactions t USING(account_id)
	WHERE t.status = 'completed'
) query_rank
WHERE transaction_rank <= 2;


-- Q.103
-- Find merchant categories where MORE than 50% of transactions are payments (vs deposits, withdrawals etc).
-- Show category, total transactions, payment count and payment percentage.
SELECT
m.category,
COUNT(t.transaction_id) AS transaction_total,
SUM(CASE WHEN t.transaction_type = 'payment' THEN 1 ELSE 0 END) AS payment_count,
ROUND(
SUM(CASE WHEN t.transaction_type = 'payment' THEN 1 ELSE 0 END) / NULLIF(COUNT(t.transaction_id),0) * 100,1)
AS payment_percentage
FROM merchants m
JOIN transactions t USING(merchant_id)
WHERE t.status = 'completed'
GROUP BY m.category
HAVING payment_percentage > 0.5;

-- Q.104
-- For each customer, show whether they have MORE deposits than withdrawals (net positive)
-- or MORE withdrawals than deposits (net negative) in their transaction history.
WITH cte_txn_history AS(
SELECT
a.account_id,
SUM(CASE
WHEN t.transaction_type = 'deposit' THEN t.amount ELSE 0 END) AS total_deposit,
SUM(CASE
WHEN t.transaction_type = 'withdrawal' THEN t.amount ELSE 0 END) AS total_withdrawals
FROM transactions t
JOIN accounts a USING(account_id)
JOIN customers c USING(customer_id)
WHERE t.status = 'completed'
GROUP BY a.account_id)
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
a.account_id,
total_deposit,
total_withdrawals,
CASE
WHEN total_deposit > total_withdrawals THEN 'net positive'
WHEN total_deposit < total_withdrawals THEN 'net withdrawal'
END AS conditional_comparision
FROM cte_txn_history
JOIN accounts a USING(account_id)
JOIN customers c USING(customer_id);

-- Q.105
-- Using a CTE, find customers whose account was opened more than 2 years ago but have made fewer than 3 transactions total.
-- These are low-engagement legacy customers.
WITH cte_account_open_report AS
(
SELECT
a.account_id,
MIN(a.opened_date) AS account_openDate
FROM accounts a
WHERE a.status = 'active' AND TIMESTAMPDIFF(YEAR, a.opened_date, CURDATE()) >= 2
GROUP BY a.account_id
), cte_transactionCount_report AS (
SELECT
a.account_id,
COUNT(t.transaction_id) AS total_transaction
FROM accounts a
JOIN transactions t USING(account_id)
WHERE a.status = 'active' AND t.status = 'completed'
GROUP BY a.account_id
)
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
account_id,
account_openDate,
total_transaction
FROM cte_account_open_report
JOIN cte_transactionCount_report USING(account_id)
JOIN accounts a USING(account_id)
JOIN customers c USING(customer_id)
WHERE total_transaction < 3;
