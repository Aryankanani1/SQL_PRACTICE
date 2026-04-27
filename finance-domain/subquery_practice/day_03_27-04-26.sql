-- Q.14
-- Find all branches that have NO employees assigned to them. Use NOT EXISTS.
SELECT
b.branch_id,
b.branch_name,
b.city
FROM branches b
WHERE NOT EXISTS (
SELECT
1
FROM employees e
WHERE e.branch_id = b.branch_name
);

-- Q.15 scaler sub query
-- Show each employee with their salary AND the highest salary in their own department.
-- Show the gap below the top.
SELECT
e.employee_id,
CONCAT(e.first_name,'_',e.last_name) AS full_name,
e.salary,
e.department,
(SELECT
MAX(salary) AS highest_salary
FROM employees
WHERE department = e.department
) AS highest_salary
FROM employees e;

-- Q.16
-- Find the account type with the highest average balance. Use a derived table in FROM.
SELECT
ROUND(MAX(average_balance),2) AS highest_average_balance
FROM (
SELECT
account_type,
AVG(balance) AS average_balance
FROM accounts
WHERE status = 'active'
GROUP BY account_type
) average_account_type;

-- Q.17
-- Find all transactions where the amount is greater than 3x
-- the average transaction amount for THAT specific account.
SELECT
a.account_id,
t.transaction_id,
t.amount,
t.transaction_type,
	(SELECT
	AVG(amount) AS average_transaction
	FROM transactions
	WHERE account_id = a.account_id
	) AS average_transaction
FROM transactions t
JOIN accounts a USING(account_id)
WHERE t.amount > 3 * (
	SELECT
	AVG(amount) AS average_transaction
	FROM transactions ts
	JOIN accounts USING(account_id)
	WHERE account_id = a.account_id
	AND ts.status = 'completed'
);


-- Q.18
-- Find all customers who made a payment to BOTH Amazon (merchant_id=1) AND Starbucks (merchant_id=7).
-- Use two IN subqueries.
SELECT
c.customer_id,
CONCAT(c.first_name, '_', c.last_name) AS full_name,
m.merchant_id,
m.name AS merchant_name,
t.amount
FROM customers c
JOIN accounts a USING(customer_id)
JOIN transactions t USING(account_id)
JOIN merchants m USING(merchant_id)
WHERE account_id IN (
SELECT
distinct account_id
FROM transactions
WHERE merchant_id = 1
) AND account_id IN (
SELECT
distinct account_id
FROM transactions
WHERE merchant_id = 7
) AND t.status = 'completed';

-- Q.19
-- Find all accounts that have at least one PENDING transaction. Use EXISTS.
SELECT
a.account_id,
t.transaction_id,
t.amount,
t.status
FROM transactions t
JOIN accounts a USING(account_id)
WHERE EXISTS (
SELECT
1
FROM transactions
WHERE account_id = a.account_id
AND t.status = 'pending'
);
