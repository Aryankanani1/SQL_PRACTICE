-- Q.92 Easy
-- Calculate the month-over-month change in total transaction volume for 2024.
-- Show month, total volume, previous month volume and the change amount.
USE sql_finance;

WITH cte_total_monthly_transaction AS
(SELECT
MONTH(t.transaction_date) AS monthly,
SUM(t.amount) AS total_amount,
COUNT(*) AS total_volume
FROM transactions t
WHERE t.status = 'completed'
GROUP BY MONTH(t.transaction_date))
SELECT
*,
LAG(total_amount) OVER(ORDER BY monthly),
ROUND(total_amount - LAG(total_amount) OVER(ORDER BY monthly)) AS total_difference
FROM cte_total_monthly_transaction;


-- Q.93 Easy
-- Find all branches where the average employee salary is above the overall company average.
-- Show branch name, city, employee count and average salary.
SELECT
b.branch_name,
b.city,
COUNT(*) AS total_employees,
AVG(salary) AS average_salary
FROM branches b
JOIN employees USING(branch_id)
GROUP BY branch_name, b.city
HAVING average_salary > (SELECT AVG(salary) FROM employees);

-- Q.94 Medium
-- Find all accounts where the total withdrawals exceed the total deposits.
-- These accounts have net negative cash flow.
SELECT
*,
ROUND(total_deposit - total_withdrawal) AS net_flow
FROM
(SELECT
a.account_id,
SUM(CASE WHEN t.transaction_type = 'deposit' THEN t.amount ELSE 0 END) AS total_deposit,
SUM(CASE WHEN t.transaction_type IN('withdrawal','transfer','payment') THEN t.amount ELSE 0 END) AS total_withdrawal
FROM accounts a
JOIN transactions t USING(account_id)
WHERE t.status = 'completed'
GROUP BY account_id
HAVING total_withdrawal > total_deposit) sb;


-- Q.95 Medium
-- Show each transaction with its percentage of the total monthly volume.
-- Show month, transaction_id, amount and pct of monthly total.
SELECT
*,
ROUND((amount / total_monthly_volume) * 100,2)
FROM (
SELECT
t.transaction_id,
MONTH(t.transaction_date) AS mo,
t.amount,
SUM(t.amount) OVER(PARTITION BY MONTH(t.transaction_date)) AS total_monthly_volume
FROM transactions t
WHERE t.status = 'completed'
) sb
ORDER BY mo, amount DESC;
