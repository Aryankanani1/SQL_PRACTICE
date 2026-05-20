-- Q.141
-- Count total number of transactions per account.
-- Show account_id and transaction count. Only show accounts with more than 2 transactions.
USE sql_finance;
EXPLAIN SELECT
t.account_id,
COUNT(*) AS total_transaction
FROM transactions t
WHERE t.status = 'completed'
GROUP BY t.account_id
HAVING total_transaction > 2
ORDER BY t.account_id ASC;

CREATE INDEX indx_141 ON transactions (status,account_id);

-- Q.142
-- Find all employees with a salary above $100,000.
-- Show full name, department, salary and branch_id. Order by salary descending.
EXPLAIN SELECT
CONCAT(e.first_name,'_',e.last_name) AS full_name,
e.department,
e.salary,
e.branch_id
FROM employees e
WHERE e.salary > 100000
ORDER BY e.salary DESC;

CREATE INDEX indx_142 ON employees (salary,department,branch_id);

-- Q.143
-- What is the total balance held in each account type across all active accounts?
-- Show account_type, count and total balance.
EXPLAIN SELECT
a.account_type,
COUNT(*) AS total_account,
SUM(a.balance) AS total_balance
FROM accounts a
WHERE a.status = 'active'
GROUP BY a.account_type
ORDER BY COUNT(*) DESC;

CREATE INDEX indx_143 ON accounts (status,account_type,balance);
