-- Q.25
-- Find all customers who have both a checking AND savings account.
-- Use two EXISTS subqueries.
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
a.account_id,
a.account_type,
a.status
FROM customers c
JOIN accounts a USING(customer_id)
WHERE EXISTS (
SELECT
1
FROM accounts
WHERE customer_id = c.customer_id AND a.account_type = 'checking'
) AND
(
SELECT
1
FROM accounts
WHERE customer_id = c.customer_id AND a.account_type = 'savings'
);

-- Q.26
-- Find all customers whose total account balance is above the average total balance of customers in the SAME state.
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
SUM(balance) AS total_balance
FROM customers c
JOIN accounts a USING(customer_id)
GROUP BY c.customer_id
HAVING total_balance >
(
SELECT
AVG(state_balance)
FROM
(
SELECT
SUM(balance) AS state_balance
WHERE state = c.state
) statevise_balance
);


-- Q.27
-- Find all transactions where the amount is above the average for
-- that specific transaction TYPE -- not the overall average.
SELECT
DISTINCT t.transaction_id,
t.amount,
t.transaction_type
FROM transactions t
JOIN (SELECT
transaction_type,
AVG(amount) AS average_transaction
FROM transactions
WHERE status = 'completed'
GROUP BY transaction_type
) AS average_transaction_per_category ON average_transaction_per_category.transaction_type = t.transaction_type
WHERE t.amount > average_transaction AND t.status = 'completed'
ORDER BY t.amount DESC;

-- 2nd way
SELECT
t.transaction_id,
t.amount,
t.transaction_date,
t.transaction_type
FROM transactions t
WHERE t.amount > (
SELECT
AVG(amount)
FROM transactions
WHERE transaction_type = t.transaction_type
AND status = 'completed'
) AND t.status = 'completed'
ORDER BY t.amount DESC;

-- Q.28
-- For each employee, show whether their salary is above or below the average salary of their OWN department.
-- Use a correlated subquery.
SELECT
*
FROM (
SELECT
employee_id,
CONCAT(e.first_name,'_',e.last_name) AS full_name,
e.salary,
e.department,
AVG(e.salary) OVER(PARTITION BY e.department) AS average_salary_perdepartment
FROM employees e
) AS avg_salary_department
WHERE salary > average_salary_perdepartment;

-- 2nd way
SELECT
employee_id,
CONCAT(e.first_name,'_',e.last_name) AS full_name,
e.salary,
e.department
FROM employees e
WHERE e.salary > (
SELECT
AVG(salary)
FROM employees
WHERE department = e.department
);

-- Q.29
-- Find all accounts where the most recent transaction amount is MORE than double their account average transaction amount.
WITH cte_average_transaction_per_account AS(
SELECT
a.account_id,
AVG(t.amount) AS avg_amount
FROM accounts a
JOIN transactions t USING(account_id)
WHERE t.status = 'completed'
GROUP BY a.account_id ), recent_transaction_in_accounnt AS
(
SELECT
a.account_id,
MAX(t.transaction_date) AS recent_transaction_date
FROM accounts a
JOIN transactions t USING(account_id)
GROUP BY a.account_id
)
SELECT
DISTINCT a.account_id,
a.balance,
recent_transaction_date
FROM accounts a
JOIN transactions t USING(account_id)
JOIN cte_average_transaction_per_account ca USING(account_id)
JOIN recent_transaction_in_accounnt USING(account_id)
WHERE t.amount > avg_amount * 2;
