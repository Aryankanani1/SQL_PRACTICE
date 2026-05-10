-- Q.117 HARD
-- For each customer, find their "peak spending month" - the month where they spent the most.
-- Show customer name, peak month and peak amount.
USE sql_finance;
WITH cte_monthly_totals AS(
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
MONTH(t.transaction_date) AS month_number,
MONTHNAME(t.transaction_date) AS month_name,
SUM(t.amount) AS monthly_total
FROM customers c
JOIN accounts a USING(customer_id)
JOIN transactions t USING(account_id)
WHERE t.status = 'completed'
GROUP BY c.customer_id, MONTH(t.transaction_date), c.first_name ,c.last_name,
MONTHNAME(t.transaction_date)
)
, cte_ranked_spending_month AS (
SELECT
*,
ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY monthly_total DESC) AS rn
FROM cte_monthly_totals
)
SELECT
customer_id,
full_name,
month_name,
monthly_total
FROM cte_ranked_spending_month
WHERE rn =1
ORDER BY monthly_total DESC;


-- Q.118 HARD
-- Calculate the 30-day rolling average transaction amount per account.
-- For each transaction show account_id, date, amount and 30-day rolling average.
SELECT
a.account_id,
DATE(t.transaction_date) AS transaction_date,
t.amount,
AVG(t.amount) OVER(PARTITION BY a.account_id ORDER BY t.transaction_date RANGE BETWEEN
INTERVAL 30 DAY PRECEDING AND CURRENT ROW) as 30_rolling_avg
FROM accounts a
JOIN transactions t USING(account_id)
WHERE t.status = 'completed'
ORDER BY account_id,t.transaction_date;

-- Q.119 HARD
-- Find customers who are "at risk" - they have a delinquent loan AND their total account balance is less than their monthly loan payment.
-- Show customer details and risk metrics.
WITH cte_delinquent_loan_status AS(
SELECT
c.customer_id,
CONCAT(c.first_name, '_',c.last_name) AS full_name,
l.loan_id,
l.status,
l.monthly_payment
FROM customers c
JOIN loans l USING(customer_id)
WHERE l.status = 'delinquent'
),
cte_balance AS (
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
ROUND(SUM(a.balance),2) AS total_balance
FROM customers c
JOIN accounts a USING(customer_id)
JOIN loans l USING(customer_id)
GROUP BY c.customer_id
)
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
cd.loan_id,
cd.monthly_payment,
cd.status
FROM customers c
JOIN cte_delinquent_loan_status cd USING(customer_id)
JOIN cte_balance cb USING(customer_id)
WHERE cd.monthly_payment > cb.total_balance;
