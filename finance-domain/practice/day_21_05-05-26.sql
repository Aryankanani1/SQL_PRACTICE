-- Q.96
-- Find all customers whose average monthly deposit (total deposits / months since joining) is above $1,000.
SELECT
CONCAT(c.first_name,'_',c.last_name) AS full_name,
TIMESTAMPDIFF(MONTH, c.created_at, CURDATE()) AS month_as_customer,
SUM(t.amount),
ROUND(SUM(t.amount) / NULLIF(TIMESTAMPDIFF(MONTH, c.created_at, CURDATE()),0),2) AS average_deposit
FROM customers c
JOIN accounts a USING(customer_id)
JOIN transactions t USING(account_id)
WHERE t.status = 'completed' AND t.transaction_type = 'deposit'
GROUP BY c.customer_id, CONCAT(c.first_name,'_',c.last_name), c.created_at
HAVING average_deposit > 1000;

-- Q.97
-- Find all loans where the interest rate is above the average interest rate for that loan type.
-- Show loan_id, loan_type, rate and average rate for that type.
SELECT
l.loan_id,
l.loan_type,
ROUND(l.interest_rate*100,3) AS interest_rate,
ROUND((SELECT
AVG(l1.interest_rate)
FROM loans l1
WHERE l1.loan_type = l.loan_type
)*100,3) AS AVG_interest_by_type
FROM loans l
WHERE interest_rate > ALL
(SELECT
AVG(ln.interest_rate)
FROM loans ln
WHERE ln.loan_type = l.loan_type
);


-- Q.98
-- Using a CTE, build a monthly cash flow summary per account: deposits minus withdrawals+payments for each month.
-- Show positive (surplus) and negative (deficit) months.
WITH cte_montly_cashflow_summary AS (
SELECT
a.account_id,
MONTH(t.transaction_date),
MONTHNAME(t.transaction_date),
SUM(CASE WHEN t.transaction_type IN ('deposit','refund') THEN t.amount ELSE 0 END) AS inflow,
SUM(CASE WHEN t.transaction_type IN ('withdrawal','payment','transfer') THEN t.amount ELSE 0 END) AS outflow
FROM accounts a
JOIN transactions t USING(account_id)
WHERE t.status = 'completed'
GROUP BY a.account_id, MONTH(t.transaction_date), MONTHNAME(t.transaction_date)
)
SELECT
*,
ROUND(inflow - outflow) AS net_flow,
CASE
WHEN inflow >= outflow THEN 'surplus' ELSE 'deficit'
END AS final_status
FROM cte_montly_cashflow_summary;

-- Q.99
-- Find customers who have more transactions than the average number of transactions per customer.
SELECT
c.customer_id,
COUNT(*) AS total_transaction
FROM customers c
JOIN accounts a USING(customer_id)
JOIN transactions t USING(account_id)
WHERE t.status = 'completed'
GROUP BY c.customer_id
HAVING COUNT(*) > (
SELECT
	AVG(total_transaction) AS avg_transaction
FROM (
	SELECT
	c.customer_id,
	COUNT(*) AS total_transaction
	FROM customers c
	JOIN accounts a USING(customer_id)
	JOIN transactions t USING(account_id)
	WHERE t.status = 'completed'
	GROUP BY c.customer_id
) sb
);


-- Q.100
-- Find the second highest balance account for each account type. Show account_type, account_id and balance.
SELECT
*
FROM (
SELECT
a.account_id,
a.account_type,
a.balance,
DENSE_RANK() OVER(PARTITION BY a.account_type ORDER BY a.balance DESC) AS balance_rank
FROM accounts a
) sb
WHERE balance_rank = 2;
