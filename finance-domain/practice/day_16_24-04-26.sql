-- Q.76 Medium
-- Find all customers who have spent more than $500 in total across all payment transactions.
-- Show customer name, number of payments and total spent.
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
SUM(t.amount) AS total_payment_across_all_transaction
FROM customers c
JOIN accounts a USING(customer_id)
JOIN transactions t USING(account_id)
WHERE t.status = 'completed' AND t.transaction_type = 'payment'
GROUP BY c.customer_id
HAVING total_payment_across_all_transaction > 500;


-- Q.77 Medium
-- Find all accounts whose balance is less than the average balance of accounts of the SAME type.
-- Show account_id, type, balance and the type average.
SELECT
a.account_id,
a.account_type,
a.balance,
(SELECT AVG(balance)
FROM accounts
WHERE account_type = a.account_type AND status = 'active'
) AS type_average
FROM accounts a
WHERE a.balance < (
SELECT
AVG(a.balance) AS average_balance
FROM accounts a
WHERE account_type = a.account_type AND
status = 'active'
) AND a.status = 'active'
ORDER BY a.account_type, a.balance;

-- Q.78 Medium
-- Using a CTE, show each customer's most recently opened account.
-- Show customer name, account_id, account_type and opened_date.
WITH cte_recent_opened_accounts AS (SELECT
a.account_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
a.account_type,
a.opened_date,
ROW_NUMBER() OVER(PARTITION BY c.customer_id ORDER BY a.opened_date DESC) AS recent_account_open
FROM customers c
JOIN accounts a USING(customer_id))
SELECT
*
FROM cte_recent_opened_accounts
WHERE recent_account_open = 1;

-- Q.79 Medium
-- For each employee, show their salary, the next higher salary in the company (LEAD),
-- and how much they would need to earn to match it.
SELECT
e.employee_id,
CONCAT(e.first_name,'_',e.last_name) AS full_name,
e.salary,
e.department,
LEAD(e.salary) OVER(ORDER BY e.salary) AS next_higher_salary,
ROUND(LEAD(e.salary) OVER(ORDER BY e.salary) - (salary),2) AS difference
FROM employees e;

-- Q.80 Medium
-- For each loan, show each payment with the cumulative percentage of the loan that has been paid off at each payment.
-- Show loan_id, payment_date, amount_paid and pct_paid_off.
SELECT
l.loan_id,
lp.payment_date,
lp.amount_paid,
lp.principal_paid,
SUM(lp.principal_paid) OVER(PARTITION BY l.loan_id
ORDER BY payment_date
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) / l.principal_amount * 100 AS cumulative_perccentage
FROM loans l
JOIN loan_payments lp USING(loan_id);

-- Q.81 Medium
-- Find accounts where the most recent transaction was a withdrawal or payment (not a deposit).
-- These accounts are spending but not receiving income.
SELECT
t.account_id,
t.amount,
t.transaction_type,
t.transaction_date
FROM transactions t
WHERE t.transaction_date = (
       SELECT
       MAX(transaction_date)
       FROM transactions
       WHERE account_id = t.account_id
       AND status = 'completed'
       ) AND t.status = 'completed' AND
	   t.transaction_type IN('payment','withdrawal')
ORDER BY t.transaction_date DESC;
