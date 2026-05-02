-- Q.30 Find all customers who have a loan BUT have never made a loan payment.
-- Use EXISTS and NOT EXISTS.
USE sql_finance;
SELECT
c.customer_id,
CONCAT(c.first_name, '_',c.last_name) AS full_name
FROM customers c
WHERE EXISTS (
SELECT
1
FROM loans ln
WHERE ln.customer_id = c.customer_id
AND ln.status = 'active'
) AND NOT EXISTS (
SELECT
1
FROM loans l
JOIN loan_payments lp USING(loan_id)
WHERE l.customer_id = c.customer_id
AND l.status = 'active'
);

-- Q.31
-- For each merchant, find their single largest transaction using a correlated subquery in SELECT.
-- Show merchant name, category and max transaction.
SELECT
m.merchant_id,
m.name AS merchant_name,
(SELECT MAX(t.amount) FROM transactions t WHERE t.merchant_id = m.merchant_id
AND t.status = 'completed') AS max_transaction,
m.category
FROM merchants m
ORDER BY max_transaction DESC;


-- Q.32
-- Find all accounts that have had a failed transaction but have NEVER had a reversed transaction.
-- Use EXISTS and NOT EXISTS.
SELECT
a.account_id,
a.balance,
a.account_type,
a.opened_date
FROM accounts a
WHERE EXISTS (
SELECT
1
FROM transactions t
WHERE t.account_id = a.account_id
AND t.status = 'failed'
) AND NOT EXISTS (
SELECT
1
FROM transactions ts
WHERE ts.account_id = a.account_id
AND ts.status = 'reversed'
);

-- Q.33
-- Find all employees who earn more than EVERY employee in the retail department. Use ALL operator.
SELECT
e.employee_id,
CONCAT(e.first_name,'_',e.last_name) AS full_name,
e.salary,
e.department
FROM employees e
WHERE e.salary > ALL(
SELECT
employee_id
FROM employees
WHERE department = 'retail'
)
AND e.department != 'retail';

-- Q.34
-- Find all customers who made at least one transaction in January 2024 AND at least one in February 2024.
-- Use IN subqueries.
SELECT
DISTINCT c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name
FROM customers c
WHERE c.customer_id IN (
SELECT
DISTINCT c.customer_id
FROM customers c
JOIN accounts a USING(customer_id)
JOIN transactions t USING(account_id)
WHERE t.status = 'completed' AND MONTH(t.transaction_date) = 1 AND
YEAR(t.transaction_date) = 2024)
AND c.customer_id IN(
SELECT
DISTINCT c.customer_id
FROM customers c
JOIN accounts a USING(customer_id)
JOIN transactions t USING(account_id)
WHERE t.status = 'completed' AND MONTH(t.transaction_date) = 2 AND
YEAR(t.transaction_date) = 2024
);

-- Q.35
-- Find the department with the lowest total payroll. Use a derived table.
SELECT
*
FROM (
SELECT
DISTINCT e.department,
SUM(e.salary) OVER(PARTITION BY e.department) AS total_salary_by_department
FROM employees e
) sb
ORDER BY total_salary_by_department
LIMIT 1;
