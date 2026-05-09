-- Q.111
-- Find employees who report to the same manager AND work in the same department AND have a salary difference of less than $10,000.
-- These are peer comparison pairs.
SELECT
e1.employee_id,
CONCAT(e1.first_name,'_',e1.last_name) AS employee_1,
CONCAT(e2.first_name,'_',e2.last_name) AS employee_2,
e1.reports_to,
e1.department,
ABS(e1.salary - e2.salary) AS salary_diff
FROM employees e1
JOIN employees e2 ON e1.reports_to = e1.reports_to AND e1.department = e2.department AND e1.employee_id < e2.employee_id
WHERE ABS(e1.salary - e2.salary) < 10000 AND e1.department = e2.department;

-- Q.112
-- Using a CTE, show customers who received a salary deposit in January 2024 AND
-- also made a loan payment in January 2024 on the SAME day or within 3 days of the deposit.
WITH cte_salary_deposit_jan_2024 AS(
SELECT
c.customer_id,
t.amount,
DATE(t.transaction_date) AS deposit_date
FROM customers c
JOIN accounts a USING(customer_id)
JOIN transactions t USING(account_id)
WHERE t.status = 'completed' AND  YEAR(t.transaction_date) = 2024
AND MONTHNAME(t.transaction_date) = 'January' AND description LIKE '%Payroll deposit%'
),
cte_loan_jan_2024 AS (
SELECT
c.customer_id,
DATE(lp.payment_date) AS loan_payment_date,
lp.amount_paid
FROM loan_payments lp
JOIN loans l USING(loan_id)
JOIN customers c USING(customer_id)
WHERE MONTHNAME(lp.payment_date) = 'January' AND YEAR(lp.payment_date) = 2024
)
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
ABS(DATEDIFF(loan_payment_date,deposit_date)) AS diff_date
FROM customers c
JOIN cte_salary_deposit_jan_2024 USING(customer_id)
JOIN cte_loan_jan_2024 USING(customer_id)
WHERE ABS(DATEDIFF(loan_payment_date,deposit_date)) <= 3;

-- Q.113
-- For each account type, show the top, middle and bottom account by balance.
-- Label each as "Top", "Middle", or "Bottom" using NTILE(3).
SELECT
a.account_id,
a.account_type,
a.balance,
ntile(3) OVER(PARTITION BY a.account_type ORDER BY a.balance) AS balance_tier,
CASE ntile(3) OVER(PARTITION BY a.account_type ORDER BY a.balance)
WHEN 3 THEN 'top'
WHEN 2 THEN 'middle'
WHEN 1 THEN 'bottom'
END tier_label
FROM accounts a;

-- Q.114
-- Find departments where the maximum salary is more than DOUBLE the minimum salary in that department.
-- This indicates large pay dispersion.
SELECT
e.department,
MAX(e.salary) AS maximun_salary,
MIN(e.salary) AS minimum_salary
FROM employees e
GROUP BY e.department
HAVING maximun_salary > minimum_salary * 2;


-- Q.115
-- Using a CTE, identify customers who have upgraded their account portfolio
-- - opened an investment account AFTER already having a checking or savings account.
WITH cte_investment_accounts AS(
SELECT
c.customer_id,
a.account_id,
MIN(DATE(a.opened_date)) AS investment_account_date,
a.account_type
FROM accounts a
JOIN customers c USING(customer_id)
WHERE a.account_type = 'investment' AND a.status = 'active'
GROUP BY c.customer_id,
a.account_id,a.account_type
),
cte_checkFor_savings_checking AS (
SELECT
c.customer_id,
a.account_id,
MIN(DATE(a.opened_date)) AS account_open_date,
a.account_type
FROM accounts a
JOIN customers c USING(customer_id)
WHERE a.account_type IN('savings','checking') AND a.status = 'active'
GROUP BY c.customer_id,
a.account_id,a.account_type
)
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
DATEDIFF(inv.investment_account_date,che.account_open_date) AS Day_portfolio_diff
FROM customers c
JOIN cte_investment_accounts inv USING(customer_id)
JOIN cte_checkFor_savings_checking che USING(customer_id)
WHERE inv.investment_account_date > che.account_open_date;

-- Q.116
-- Find the customer who has the most diverse account portfolio -
-- holding the highest number of DIFFERENT account types. Show name and how many different types they hold.
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
COUNT(DISTINCT a.account_type) as no_differnetAccount,
GROUP_CONCAT(DISTINCT a.account_type) AS accounts_name
FROM customers c
JOIN accounts a USING(customer_id)
WHERE a.status = 'active'
GROUP BY c.customer_id
ORDER BY no_differnetAccount DESC
LIMIT 2;
