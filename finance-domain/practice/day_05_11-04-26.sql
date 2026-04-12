-- Q.24 Hard 
-- Find customers who have increased their average transaction amount 
-- in February 2024 compared to January 2024 by more than 20%
WITH cte_jan_avg_transaction AS 
(
SELECT 
c.customer_id,
ROUND(AVG(t.amount),2) AS average_jan_transaction
FROM transactions t 
JOIN accounts a USING(account_id)
JOIN customers c USING(customer_id)
WHERE YEAR(t.transaction_date) = 2024 AND MONTH(transaction_date) = 1 AND t.status = 'completed'
GROUP BY c.customer_id
), cte_feb_avg_transaction AS (
SELECT 
c.customer_id,
ROUND(AVG(t.amount),2) AS average_feb_transaction
FROM transactions t 
JOIN accounts a USING(account_id)
JOIN customers c USING(customer_id)
WHERE YEAR(t.transaction_date) = 2024 AND MONTH(transaction_date) = 2 AND t.status = 'completed'
GROUP BY c.customer_id
)
SELECT 
c.customer_id,
CONCAT(c.first_name, '_',c.last_name) AS full_name,
average_jan_transaction,
average_feb_transaction,
ROUND((average_feb_transaction - average_jan_transaction) / NULLIF(average_jan_transaction,0) * 100 , 1) AS prec_change
FROM customers c 
JOIN cte_jan_avg_transaction USING(customer_id)
JOIN cte_feb_avg_transaction USING(customer_id)
WHERE (average_feb_transaction - average_jan_transaction) / NULLIF(average_jan_transaction, 0) > 0.2
ORDER BY prec_change DESC;

-- Q.25 Hard 
-- Identify accounts showing a "spending spike" - 
-- their last transaction was more than 3 times their average transaction amount.
-- Flag them for fraud review.
WITH cte_average_transaction_amount AS(
SELECT 
a.account_id,
AVG(t.amount) AS average_transaction_amount
FROM transactions t
JOIN accounts a USING(account_id)
GROUP BY a.account_id), 
cte_rank_last_transaction AS(
SELECT 
account_id,
t.amount,
ROW_NUMBER() OVER(PARTITION BY account_id ORDER BY transaction_date DESC) AS rank_last_transaction
FROM transactions t), 
cte_last_transaction AS (SELECT 
account_id, 
amount as last_transaction
FROM cte_rank_last_transaction 
JOIN accounts a USING(account_id)
WHERE rank_last_transaction = 1)
SELECT 
account_id, 
CASE 
	WHEN last_transaction > (3 * average_transaction_amount) THEN 'fraud review'
    ELSE 'normal'
    END AS spending_spike
FROM accounts a 
JOIN cte_average_transaction_amount cta USING(account_id)  
JOIN cte_last_transaction cll USING(account_id);
