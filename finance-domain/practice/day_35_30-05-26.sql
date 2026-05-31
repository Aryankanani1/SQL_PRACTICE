-- 157
-- Find customers who have been consistently increasing their monthly spending for 3 consecutive months in 2024.
-- Show customer name and their monthly amounts.
USE sql_finance;
WITH cte_monthly_tnx AS
(SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
SUM(t.amount) AS monthly_tnx_amount,
MONTH(t.transaction_date) AS mo
FROM customers c
JOIN accounts a USING(customer_id)
JOIN transactions t USING(account_id)
WHERE t.status = 'completed' AND
	   t.transaction_date >= '2024-01-01' AND t.transaction_date < '2025-01-01'
GROUP BY c.customer_id, c.first_name,c.last_name, MONTH(t.transaction_date))
, cte_last_two_month_transaction AS(
SELECT
customer_id,
monthly_tnx_amount,
mo,
LAG(monthly_tnx_amount,1) OVER(PARTITION BY customer_id ORDER BY mo) AS prev1,
LAG(monthly_tnx_amount,2) OVER(PARTITION BY customer_id ORDER BY mo) AS prev2
FROM cte_monthly_tnx
)
SELECT
customer_id,
mo,
monthly_tnx_amount
FROM cte_last_two_month_transaction
WHERE prev1 > prev2
AND prev2 IS NOT NULL;

-- 158
-- Find all transactions that occurred on the same day as a loan payment for the same customer.
-- Show transaction details alongside the loan payment amount.
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
t.transaction_date,
t.amount
FROM customers c
JOIN accounts a USING(customer_id)
JOIN transactions t USING(account_id)
WHERE t.status = 'completed' AND EXISTS
(SELECT
1
FROM loan_payments lp
JOIN loans l USING(loan_id)
WHERE c.customer_id = l.customer_id AND
t.transaction_date = lp.payment_date);
