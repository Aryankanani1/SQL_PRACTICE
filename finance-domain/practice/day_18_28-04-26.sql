-- Q.85 Medium
-- Using a CTE, calculate what percentage of each customer's total spending went to each merchant category.
WITH cte_total_spending_percustomer AS
(
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
SUM(t.amount) AS total_spending
FROM customers c
JOIN accounts a USING(customer_id)
JOIN transactions t USING(account_id)
WHERE t.status = 'completed' AND t.transaction_type = 'payment'
GROUP BY(c.customer_id)
), cte_category_spending AS (
SELECT
a.customer_id,
SUM(t.amount) AS total_spent_per_merchant,
m.category
FROM accounts a
JOIN transactions t USING(account_id)
JOIN merchants m USING(merchant_id)
WHERE t.status = 'completed' AND t.transaction_type = 'payment'
GROUP BY a.customer_id, m.category
)
SELECT
c.customer_id,
CONCAT(c.first_name, '_', c.last_name) AS full_name,
category,
total_spent_per_merchant,
ROUND(total_spent_per_merchant / total_spending * 100) AS percentage_of_total_speding_per_merchant
FROM cte_total_spending_percustomer
JOIN cte_category_spending USING(customer_id)
JOIN customers c USING(customer_id);


-- Q.86 Medium
-- For each transaction, show how many days since the previous transaction on the SAME account.
-- Show account_id, date, amount and days_since_last.
SELECT
a.account_id,
t.transaction_date,
t.amount,
DATEDIFF(t.transaction_date,
LAG(t.transaction_date)
OVER(PARTITION BY a.account_id
ORDER BY t.transaction_date)) AS days_since_last
FROM accounts a
JOIN transactions t USING(account_id)
WHERE t.status = 'completed';


-- Q.87 Medium
-- Find employees whose salary is more than 20% above the average salary of their department.
-- Show name, department, salary and department average.
SELECT
CONCAT(e.first_name,'_',e.last_name) AS full_name,
e.department,
e.salary,
average_salary
FROM employees e
JOIN (
SELECT
department,
AVG(salary) AS average_salary
FROM employees
GROUP BY department
) average_salary_per_department USING(department)
WHERE salary > average_salary * 1.2;


-- Q.88 Medium
-- Using a CTE, find all accounts that had at least one deposit but zero payments in January 2024.
-- These accounts received money but spent nothing.
WITH cte_deposite_in_jan AS (
SELECT
a.account_id,
COUNT(t.transaction_id) AS total_transaction,
MONTH(t.transaction_date),
YEAR(t.transaction_date),
t.transaction_type
FROM accounts a
JOIN transactions t USING(account_id)
WHERE t.status = 'completed' AND t.transaction_type = 'deposit'
AND MONTH(t.transaction_date) = 1 AND YEAR(t.transaction_date) = 2024
GROUP BY a.account_id, MONTH(t.transaction_date), YEAR(t.transaction_date)
)
, cte_total_payment AS (
SELECT
a.account_id,
COUNT(t.transaction_id) AS total_transaction,
MONTH(t.transaction_date),
YEAR(t.transaction_date)
FROM accounts a
JOIN transactions t USING(account_id)
WHERE t.status = 'completed' AND t.transaction_type = 'payment'
AND MONTH(t.transaction_date) = 1 AND YEAR(t.transaction_date) = 2024
GROUP BY a.account_id, MONTH(t.transaction_date), YEAR(t.transaction_date)
)
SELECT
d.account_id,
a.account_type,
d.transaction_type
FROM cte_deposite_in_jan d
LEFT JOIN cte_total_payment p USING(account_id)
JOIN accounts a USING(account_id)
WHERE p.account_id IS NULL;
