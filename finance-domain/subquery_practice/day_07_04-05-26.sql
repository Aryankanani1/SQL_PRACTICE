-- Q.36
-- Find all customers who have a delinquent loan AND a frozen account.
-- Both conditions must be true. Use EXISTS twice.
USE sql_finance;
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
a.account_id,
a.account_type,
a.balance
FROM customers c
JOIN accounts a USING(customer_id)
WHERE EXISTS (
SELECT
1
FROM loans l
WHERE l.customer_id = a.customer_id AND l.status = 'delinquent'
) AND (
SELECT
1
FROM accounts ac
WHERE ac.customer_id = a.customer_id AND ac.status = 'frozen'
);


-- Q.37
-- Show the month-over-month change in new accounts opened.
-- Use a derived table self-joined for the previous month.
SELECT
curr.current_year,
previo.previous_year,
ROUND(curr.total_account - COALESCE(previo.total_account,0))
FROM(
SELECT
YEAR(a.opened_date) AS current_year,
MONTH(a.opened_date) AS current_month_account_open_date,
MONTHNAME(a.opened_date) AS month_name,
COUNT(a.account_id) AS total_account
FROM accounts a
GROUP BY YEAR(a.opened_date), MONTH(a.opened_date), MONTHNAME(a.opened_date)
) curr
LEFT JOIN (
SELECT
YEAR(a.opened_date) AS previous_year,
MONTH(a.opened_date) AS previous_month_account_open_date,
MONTHNAME(a.opened_date) AS month_name,
COUNT(a.account_id) AS total_account
FROM accounts a
GROUP BY YEAR(a.opened_date), MONTH(a.opened_date), MONTHNAME(a.opened_date)
) previo ON curr.current_month_account_open_date = previo.previous_month_account_open_date + 1;


-- Q.38
-- Find all loan payments where the interest paid is greater than 50% of the total amount paid -- high-interest burden payments.
SELECT
lp.loan_id,
lp.payment_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
ROUND(interest_paid/amount_paid*100) AS total_paid,
l.loan_type,
ROUND((SELECT
AVG(interest_paid/amount_paid) FROM loan_payments
WHERE loan_id = lp.loan_id
)*100 ,2) AS loan_avg_interest_pct
FROM loan_payments lp
JOIN loans l USING(loan_id)
JOIN customers c USING(customer_id)
WHERE lp.interest_paid > lp.amount_paid * 0.5;
