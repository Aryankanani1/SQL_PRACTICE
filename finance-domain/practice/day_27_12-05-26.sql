-- Q.122
-- Find all customers who have both a checking account balance below $2,000 AND an active loan payment due this month.
-- These are financially stressed customers.
USE sql_finance;
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name
FROM customers c
WHERE EXISTS (
SELECT
1
FROM accounts a
WHERE a.customer_id = c.customer_id
AND a.account_type = 'checking'
AND a.balance < 2000 AND a.status = 'active'
)
AND EXISTS (
SELECT
1
FROM loans l
JOIN loan_payments lp USING(loan_id)
WHERE l.customer_id = c.customer_id AND MONTH(lp.payment_date) = 5
);


-- Q.123
-- Calculate the cumulative loan interest income over time.
-- For each loan payment date, show the running total of all interest collected bank-wide.
SELECT
lp.payment_date,
l.loan_id,
l.loan_type,
lp.interest_paid,
SUM(lp.interest_paid) OVER(ORDER BY lp.payment_date ROWS BETWEEN UNBOUNDED
PRECEDING AND CURRENT ROW)
FROM loan_payments lp
JOIN loans l USING(loan_id);


-- Q.124
-- Find pairs of accounts that transacted on the same day with the same amount
-- - potential duplicate transactions or money laundering patterns.
SELECT
t.account_id,
t.amount,
DATE(t.transaction_date) AS transction_date,
t1.account_id,
t1.amount,
DATE(t1.transaction_date) AS transction_date
FROM  transactions t
LEFT JOIN transactions t1 ON t1.account_id > t.account_id
AND t.amount = t1.amount AND t.transaction_type = t1.transaction_type
WHERE t.status ='completed' AND t.amount = t1.amount AND DATE(t.transaction_date) = DATE(t1.transaction_date);

-- Q.125
-- Build a complete customer financial health score: combine balance score (0-40 pts),
-- activity score (0-30 pts) and loan health score (0-30 pts). Show top 5 healthiest customers.
WITH cte_balance_score AS(SELECT
a.customer_id,
CASE WHEN SUM(a.balance) >= 100000 THEN 40
     WHEN SUM(a.balance) >= 10000 THEN 30
     WHEN SUM(a.balance) >= 5000 THEN 20
     WHEN SUM(a.balance) >= 1000 THEN 10
     ELSE 0 END points
FROM accounts a
WHERE a.status = 'active'
GROUP BY customer_id)
,
cte_activity_score AS(
SELECT
a.customer_id,
CASE WHEN COUNT(t.transaction_id) >= 10 THEN 20
	 WHEN COUNT(t.transaction_id) >= 7 THEN 15
     WHEN COUNT(t.transaction_id) >= 5 THEN 10
     WHEN COUNT(t.transaction_id) >= 2 THEN 5
     ELSE 0 END points
FROM accounts a
JOIN transactions t USING(account_id)
WHERE t.status ='completed'
GROUP BY a.customer_id
),
cte_loan_score AS (
SELECT
l.customer_id,
CASE WHEN SUM(CASE WHEN l.status IN('deliquent','default') THEN 1 ELSE 0 END) > 0 THEN 0
		WHEN COUNT(*) >= 1 THEN 15
        ELSE 0 END points
FROM loans l
GROUP BY l.customer_id
)
SELECT
DENSE_RANK() OVER(ORDER BY (bs.points + acs.points + ls.points) DESC) AS customer_rank,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
ROUND(bs.points + acs.points + ls.points) AS total_points
FROM customers c
JOIN cte_balance_score bs USING(customer_id)
JOIN cte_activity_score acs USING(customer_id)
JOIN cte_loan_score ls USING(customer_id)
LIMIT 5;
