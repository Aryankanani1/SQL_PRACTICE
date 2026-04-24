-- Q.72 Medium
-- Using a CTE, find the average transaction amount per merchant category, then show only
-- transactions that are 2x above their category average (potential outliers).
WITH cte_average_transaction_per_merchant AS
(
SELECT
ROUND(AVG(t.amount),2)AS avg_amount,
m.category
FROM transactions t
JOIN merchants m USING(merchant_id)
WHERE t.status = 'completed'
GROUP BY m.category
)
SELECT
t.transaction_id,
avg_amount,
m.category
FROM transactions t
JOIN merchants m USING(merchant_id)
JOIN cte_average_transaction_per_merchant USING(category)
WHERE t.amount > avg_amount * 2
AND t.status = 'completed';


-- Q.73 Medium
-- Find the most recent transaction for each account.
-- Show account_id, transaction_id, amount, type and date of the most recent transaction.
SELECT
t.account_id,
t.transaction_id,
t.amount,
t.transaction_type,
t.transaction_date
FROM transactions t
WHERE t.transaction_date = (
SELECT
MAX(t.transaction_date)
FROM transactions
WHERE account_id = t.account_id AND
t.status = 'completed'
) AND t.status = 'completed';

-- Q.74 Medium
-- For each customer, number their accounts in the order they were opened (first opened = 1).
-- Show customer name, account_id, account_type, opened_date and account_sequence.
SELECT
c.customer_id,
CONCAT(c.first_name,'_', c.last_name) AS full_name,
a.account_type,
a.opened_date,
ROW_NUMBER() OVER(PARTITION BY c.customer_id ORDER BY a.opened_date) AS account_sequence
FROM accounts a
JOIN customers c USING(customer_id);

-- Q.75 Medium
-- Find all customers whose average monthly deposit
-- (total deposits / months since joining) is above $1,000.
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
SUM(t.amount) AS total_deposite,
TIMESTAMPDIFF(MONTH,c.created_at,curdate()) AS months_since_joining,
ROUND(SUM(t.amount) / NULLIF(TIMESTAMPDIFF(MONTH,c.created_at,curdate()),0),2) AS average_monthly_deposit
FROM accounts a
JOIN customers c USING(customer_id)
JOIN transactions t USING(account_id)
WHERE t.status = 'completed' AND t.transaction_type = 'deposit'
GROUP BY customer_id
HAVING average_monthly_deposit > 1000;
