-- Q.154
-- Find all customers who have made at least one transaction in EVERY month of 2024 that appears in the data.
-- Show customer name and month count.
USE sql_finance;
EXPLAIN SELECT
  CONCAT(c.first_name,' ',c.last_name) AS customer,
  COUNT(DISTINCT MONTH(t.transaction_date)) AS active_months
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
WHERE transaction_date >= '2024-01-01' AND transaction_date < '2025-01-01'
  AND t.status = 'completed'
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT MONTH(t.transaction_date)) = (
  SELECT COUNT(DISTINCT MONTH(transaction_date))
  FROM transactions
  WHERE transaction_date >= '2024-01-01' AND transaction_date < '2025-01-01'
    AND status = 'completed'
)
ORDER BY active_months DESC;

CREATE INDEX indx_154 ON transactions (status,transaction_date,account_id);
CREATE INDEX indx_155 ON accounts (account_id,customer_id);


-- Q.155
-- Find customers who have more transactions than the average number of transactions per customer.
EXPLAIN WITH cte_total_count AS(
SELECT
a.customer_id,
COUNT(*) AS total_txn_count
FROM transactions t
JOIN accounts a USING(account_id)
WHERE t.status = 'completed'
GROUP BY a.customer_id
),
avg_transaction_count AS(
SELECT
AVG(total_txn_count) AS avg_transaction_count
FROM cte_total_count
)
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
total_txn_count
FROM customers c
JOIN cte_total_count USING(customer_id)
JOIN avg_transaction_count ON avg_transaction_count < total_txn_count;

CREATE INDEX indx_155 ON transactions (status,account_id);
CREATE INDEX indx_155 ON customers (customer_id,first_name,last_name);
CREATE INDEX indx_155 ON accounts (account_id,customer_id);


-- Q.156
-- Using a CTE, find accounts that have been completely inactive (zero transactions)
-- for more than 90 days from their most recent transaction.
EXPLAIN WITH cte_latest_transaction_date AS(
SELECT
a.account_id,
MAX(t.transaction_date) AS latest_transaction_date
FROM transactions t
JOIN accounts a USING(account_id)
WHERE t.status = 'completed'
GROUP BY a.account_id
HAVING MAX(t.transaction_date) < DATE_SUB(CURDATE(), INTERVAL 90 DAY)
)
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
a.account_id,
a.account_type
FROM accounts a
JOIN cte_latest_transaction_date USING(account_id)
JOIN customers c USING(customer_id)
WHERE a.status = 'active';
CREATE INDEX indx_156 ON transactions (status,transaction_date,account_id);
CREATE INDEX indx_156 ON accounts (status,account_id,customer_id,account_type);
