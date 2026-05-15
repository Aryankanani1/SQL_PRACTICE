-- Q.126
-- Find all employees hired after January 1st, 2019 in the loans or investments department.
-- Show full name, department, salary and hire date.
USE sql_finance;
SELECT
CONCAT(e.first_name,'_',e.last_name) AS full_name,
e.department,
e.salary,
e.hire_date
FROM employees e
WHERE e.hire_date >= '2019-01-01' AND e.department IN ('loans','investments');


-- Q.127
-- How many transactions occurred per month in 2024? Show year, month name, transaction count and total amount.
CREATE INDEX indx_status_date_amount ON transactions (status,transaction_date,amount);
EXPLAIN SELECT
/*do not use YEAR(t.transaction_date) because if we create index then mysql can't able to use this expression because
it it wrapped with YEAR() so remove the YEAR() function */
-- YEAR(t.transaction_date) AS yr,
2024 AS yr,
MONTHNAME(t.transaction_date) AS month_name,
COUNT(t.transaction_id) AS transaction_count,
SUM(t.amount)
FROM transactions t
WHERE t.status = 'completed' AND t.transaction_date >= '2024-01-01'
								AND t.transaction_date < '2025-01-01'
-- YEAR(t.transaction_date) = 2024
GROUP BY MONTH(t.transaction_date),month_name
ORDER BY MONTH(t.transaction_date);


-- Q.128
-- List all blocked or expired cards.
-- Show card_id, card_type, last4, expiry_date, status and account_id.
CREATE INDEX indx_blocked_expire ON cards (status,card_id);
-- cost(1.41) rows(2)
SELECT
c.card_id,
c.card_type,
c.card_number_last4,
c.expiry_date,
c.status,
c.account_id
FROM cards c
WHERE c.status IN('blocked','expiry_date')
ORDER BY c.status;

-- Q.129
-- What is the total principal paid vs total interest paid across all loan payments recorded?
EXPLAIN SELECT
SUM(principal_paid) AS total_principal_paid,
SUM(interest_paid) AS total_interest_paid
FROM loan_payments lp;


-- Q.130
-- Show each customer's total account balance (sum of all their accounts).
-- Show customer full name and total balance. Order by total balance descending.
CREATE INDEX idx_status_customer_balance ON accounts (status,customer_id,balance);
EXPLAIN SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
SUM(a.balance) AS total_balance
FROM customers c
JOIN accounts a USING(customer_id)
WHERE a.status = 'active'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY SUM(a.balance) DESC;

-- optimized
EXPLAIN SELECT
CONCAT(c.first_name,'_',c.last_name) AS full_name,
agg.total_balance
FROM customers c
JOIN (
SELECT
		customer_id,
        SUM(balance) AS total_balance
        FROM accounts
        WHERE status = 'active'
        GROUP BY customer_id
)agg ON c.customer_id = agg.customer_id
ORDER BY agg.total_balance;


-- Q.131
-- Find all deposit transactions over $5,000 in January 2024.
-- Show account_id, amount, date and description.
/* tip The Wall: In SQL, once the database hits a range filter in an index,
-- it can no longer use any columns that come after it for sorting.
Because account_id comes after the date, the database cannot use the index to handle your ORDER BY account_id.*/
-- (where for status,order,then range to avoid range wall)

EXPLAIN SELECT
account_id,
t.amount,
t.transaction_date,
t.description
FROM transactions t FORCE INDEX(indx_status_accountId_ransactionDate_description)
WHERE t.status = 'completed' AND t.amount > 5000 AND t.transaction_date >= '2024-01-01'
AND t.transaction_date < '2025-01-01'
ORDER BY account_id;
