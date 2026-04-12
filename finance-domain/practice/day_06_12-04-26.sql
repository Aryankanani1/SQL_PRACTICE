-- Q.27 Easy 
-- Find all savings accounts. 
-- Show the customer_id, balance, interest_rate and opened_date. Order by balance descending.
USE sql_finance;
SELECT 
c.customer_id,
a.balance,
a.interest_rate,
a.opened_date
FROM customers c 
JOIN accounts a USING(customer_id)
WHERE a.status = 'active' AND a.account_type = 'savings'
ORDER BY a.balance DESC;

-- Q.28 Easy 
-- Show all transactions made at Amazon (merchant_id = 1). 
-- Show transaction_id, account_id, amount, and transaction_date.
USE sql_finance;
SELECT 
t.transaction_id,
a.account_id,
t.amount,
t.transaction_date,
m.name AS merchants
FROM transactions t 
JOIN accounts a USING(account_id) 
JOIN merchants m USING(merchant_id)
WHERE merchant_id = 1;

-- Q.29 Easy 
-- How many customers does the bank have in total? 
-- Also how many have completed KYC verification? 
USE sql_finance;
SELECT 
COUNT(*) AS total_customers,
SUM(kyc_verified) AS kyc_verified
FROM customers;

-- Q.30 Medium
-- Find all transactions whose amount is above the average transaction amount for their account. 
-- Show account_id, transaction_id, amount and the account average.
SELECT 
t.account_id,
t.transaction_id,
t.amount,
ROUND((
SELECT AVG(amount) 
FROM
transactions t2
WHERE t2.account_id = t.account_id
AND t2.status = 'completed'
 ),2) AS account_average
FROM transactions t
WHERE amount > 
(
SELECT 
AVG(amount) AS average_transaction
FROM transactions t2
WHERE t2.account_id = t.account_id
AND t2.status = 'completed'
) AND t.status = 'completed'
ORDER BY t.account_id , t.amount DESC;

-- Q.31 Medium 
-- Find the customer with the highest single transaction amount. 
-- Show their full name, the transaction amount, type and date.
SELECT 
c.customer_id,
CONCAT(c.first_name, '_',c.last_name) AS full_name,
t.amount,
t.transaction_type,
t.transaction_date
FROM customers c 
JOIN accounts a USING (customer_id)
JOIN transactions t USING(account_id) 
WHERE t.amount = (
SELECT 
MAX(amount) AS largest_transaction
FROM transactions 
) AND t.status = 'completed';


-- Q.32 Medium 
-- For each account, show the transaction number within that account (row_number), 
-- the transaction details, and label the first and last transaction for each account.
WITH cte_each_transaction_in_account AS (
SELECT 
t.transaction_id,
t.account_id,
t.transaction_date,
ROW_NUMBER() OVER(PARTITION BY account_id ORDER BY t.transaction_date DESC) AS DESC_txn_number,
ROW_NUMBER() OVER(PARTITION BY account_id ORDER BY t.transaction_date) AS txn_number
FROM transactions t
WHERE t.status = 'completed'
)
SELECT 
*,
CASE 
WHEN txn_number = 1 THEN 'FIRST'
WHEN DESC_txn_number = 1 THEN 'LATEST'
END AS transaction_time
FROM cte_each_transaction_in_account
ORDER BY account_id, transaction_date
