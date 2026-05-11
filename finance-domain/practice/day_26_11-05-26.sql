-- Q.120
-- For each account, find transactions that are more than 2 standard deviations above the account's
-- average transaction amount (statistical outlier detection).
WITH cte_avg_amount AS(
SELECT
t.account_id,
t.amount,
AVG(t.amount) OVER(PARTITION BY t.account_id) AS avg_amount,
STDDEV(t.amount) OVER(PARTITION BY t.account_id) AS standard_deviation
FROM transactions t
WHERE t.status = 'completed'
)
SELECT
account_id,
amount,
avg_amount,
standard_deviation
FROM cte_avg_amount
WHERE amount > (avg_amount + (standard_deviation * 2));

-- Q.121
-- Detect potentially fraudulent accounts:
-- find accounts where more than 50% of their transactions happened on the same single day
-- (burst activity is a fraud signal).
WITH cte_dailyCount AS(
SELECT
account_id,
COUNT(*) AS daily_transaction_count,
DATE(transaction_date) AS txn_date
FROM transactions t
WHERE t.status = 'completed'
GROUP BY account_id, DATE(transaction_date)
),
cte_totalCount AS(
SELECT
t.account_id,
COUNT(*) AS accounts_totalCount
FROM transactions t
WHERE t.status = 'completed'
GROUP BY t.account_id),
cte_pct_on_pick_day AS(
SELECT
account_id,
txn_date,
daily_transaction_count,
accounts_totalCount,
ROUND(daily_transaction_count/NULLIF(accounts_totalCount,2)*100,2) AS pct_on_pick_day,
RANK() OVER(PARTITION BY account_id ORDER BY daily_transaction_count DESC) AS day_rank
FROM cte_dailyCount
JOIN cte_totalCount USING(account_id)
)
SELECT
a.account_id,
daily_transaction_count,
accounts_totalCount,
pct_on_pick_day,
day_rank
FROM accounts a
JOIN cte_pct_on_pick_day USING(account_id)
WHERE pct_on_pick_day > 50;
