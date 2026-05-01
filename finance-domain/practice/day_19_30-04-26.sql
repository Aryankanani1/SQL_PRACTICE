-- Q.89 Medium
-- List the top 3 highest-paid employees in each department. Show name, department, salary and rank.
SELECT
*
FROM (SELECT
e.employee_id,
CONCAT(e.first_name,'_',e.last_name) AS full_name,
e.salary,
e.department,
ROW_NUMBER() OVER(PARTITION BY e.department ORDER BY salary DESC) AS department_salary_rank
FROM employees e) sub
WHERE department_salary_rank <= 3;

-- Q.90 Medium
-- Calculate the percentage change in each account's balance compared to the average balance across all accounts.
-- Show account_id, balance, avg_balance, and pct_diff.
WITH cte_average_account AS
(SELECT
a.account_id,
a.balance,
AVG(a.balance) OVER() AS avg_balance
FROM accounts a
WHERE a.status = 'active')
SELECT
a.account_id,
a.balance,
avg_balance,
ROUND(((a.balance - avg_balance) / avg_balance * 100),2) AS pct_diff
FROM accounts a
JOIN cte_average_account USING(account_id)
WHERE a.status = 'active'
ORDER BY pct_diff DESC;

-- Q.91 Medium
-- Which customers have a total loan outstanding balance more than 5x their total account balance? Show the multiplier.
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
SUM(l.outstanding_balance) AS total_out_balance,
SUM(a.balance) AS total_account_balance,
ROUND(SUM(DISTINCT l.outstanding_balance) / SUM(a.balance),2) AS multipler
FROM customers c
JOIN accounts a USING(customer_id)
JOIN loans l USING(customer_id)
WHERE a.status = 'active' AND l.status = 'active'
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING total_out_balance > total_account_balance * 5
ORDER BY multipler DESC;
