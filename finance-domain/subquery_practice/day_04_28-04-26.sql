-- Q.20
-- Find the top 3 accounts by total transaction amount.
-- Use a derived table to aggregate first, then select top 3.
SELECT
*
FROM (
SELECT
a.account_id,
SUM(t.amount) AS total_transaction
FROM accounts a
JOIN transactions t USING(account_id)
WHERE t.status = 'completed'
GROUP BY a.account_id
ORDER BY total_transaction DESC
) top3_account
LIMIT 3;

-- Q.21
-- Show the total number of loans AND how many are above
-- the average outstanding balance -- all in one row.
SELECT
l.loan_id,
(SELECT COUNT(*) FROM loans) AS total_number_of_loans,
l.outstanding_balance,
l.status
FROM loans l
WHERE l.outstanding_balance > (
SELECT
AVG(outstanding_balance) AS outstanding_balance
FROM loans
);

-- Q.22
-- Find all employees who work in departments that have more than 1 employee. Use IN with HAVING.
SELECT
e.employee_id,
CONCAT(e.first_name,'_',e.last_name) AS full_name,
e.department,
e.salary
FROM employees e
WHERE department IN (
SELECT
department
FROM employees
GROUP BY department
HAVING COUNT(*) > 1
);

-- Q.23
-- Find all loan payments where the amount paid is less than
-- the average payment amount across all payments.
SELECT
lp.loan_id,
lp.payment_id,
lp.amount_paid
FROM loan_payments lp
WHERE lp.amount_paid <
(SELECT
AVG(amount_paid) AS average_amount_paid
FROM loan_payments);

-- Q.24
-- Find all customers whose total balance across all accounts exceeds $50,000.
-- Use a derived table to sum per customer first.
SELECT
*
FROM
(SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
SUM(a.balance) AS total_account_balance
FROM accounts a
JOIN customers c USING(customer_id)
GROUP BY c.customer_id
) highest_balance_customers
WHERE total_account_balance > 50000
ORDER BY total_account_balance DESC;
