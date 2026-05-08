-- Q.106
-- Show all loan payments with their payment number within the loan (1st payment, 2nd payment etc.)
-- and what percentage of the loan term has been completed.
USE sql_finance;
WITH cte_all_loan_payments AS(
SELECT
l.loan_id,
lp.payment_id,
lp.payment_date,
ROW_NUMBER() OVER(PARTITION BY l.loan_id ORDER BY lp.payment_date) AS all_payments
FROM loans l
JOIN loan_payments lp USING(loan_id)
WHERE l.status = 'active'
), cte_loan_completion AS (
SELECT
l.loan_id,
ROUND(
(l.principal_amount - l.outstanding_balance) / NULLIF(l.principal_amount, 0) * 100
,2) AS loan_completion
FROM loans l
WHERE l.status = 'active'
)
SELECT
DISTINCT loan_id,
payment_id,
payment_date,
all_payments,
loan_completion
FROM cte_all_loan_payments
JOIN cte_loan_completion USING(loan_id);


-- Q.107
-- Which branches have an average employee salary above $95,000?
-- Show branch name, city, employee count and average salary.
SELECT
branch_name,
b.city,
COUNT(e.employee_id) AS total_employee,
ROUND(AVG(e.salary),2) AS avg_salary
FROM employees e
JOIN branches b USING(branch_id)
GROUP BY branch_name, b.city
HAVING avg_salary > 95000;

-- Q.108
-- Using a CTE, calculate for each customer:
-- (1) total balance across all accounts,
-- (2) total outstanding debt,
-- (3) net worth (balance minus debt). Rank by net worth.
WITH cte_total_balance_all_account AS (
SELECT
c.customer_id,
SUM(a.balance) AS total_balance
FROM customers c
LEFT JOIN accounts a USING(customer_id)
GROUP BY c.customer_id
), cte_total_outstanding_debt AS (
SELECT
c.customer_id,
SUM(l.outstanding_balance) AS total_debt
FROM customers c
JOIN loans l USING(customer_id)
GROUP BY c.customer_id
)
SELECT
RANK() OVER(ORDER BY (total_balance - total_debt) DESC) AS net_worth_rank,
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
ROUND((total_balance - total_debt),2)
FROM cte_total_balance_all_account
LEFT JOIN cte_total_outstanding_debt USING(customer_id)
JOIN customers c USING(customer_id)
LIMIT 3;

-- Q.109
-- Show each account's balance as a percentage of the total balance held across all accounts of the same type.
-- Show account_id, type, balance and pct_of_type_total.
SELECT
a.account_id,
a.account_type,
a.balance,
ROUND(a.balance / NULLIF(SUM(a.balance) OVER(PARTITION BY a.account_type),0) * 100, 2) AS pct_of_balance_same_type
FROM accounts a
WHERE a.status = 'active';

-- Q.110
-- Using a CTE, find the 5 most recent transactions for each account
-- and show them with the account balance after each transaction (compute sequentially).
WITH cte_top_transaction_by_account AS(
SELECT
t.account_id,
t.transaction_id,
t.transaction_date,
t.amount,
ROW_NUMBER() OVER(PARTITION BY account_id ORDER BY t.transaction_date DESC) AS top_transaction
FROM transactions t
WHERE t.status = 'completed')
SELECT
a.account_id,
amount,
transaction_date,
top_transaction
FROM accounts a
JOIN cte_top_transaction_by_account USING(account_id)
WHERE top_transaction <= 5
ORDER BY a.account_id;
