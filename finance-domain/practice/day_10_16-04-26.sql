-- Q.47 Easy 
-- Show each transaction with the name of the merchant (if any). Include transactions with no merchant (like deposits). 
-- Show transaction_id, amount, type, date and merchant name.
SELECT 
transaction_id,
amount,
transaction_type,
transaction_date,
name AS merchant_name
FROM transactions 
LEFT JOIN merchants USING(merchant_id);

-- Q.48 Medium 
-- Find all accounts where the sum of payments exceeds 80% of the current balance. 
-- These accounts are nearly depleted by spending.
SELECT 
account_id,
CONCAT(c.first_name, '_',c.last_name) AS full_name,
a.balance,
(SELECT 
SUM(t.amount) AS total_payment
FROM transactions t 
JOIN accounts a USING(account_id)
WHERE t.status = 'completed' AND t.transaction_type = 'payment') AS total_spened
FROM accounts a 
JOIN customers c USING(customer_id) 
WHERE (SELECT 
SUM(t.amount) AS total_payment
FROM transactions t 
JOIN accounts a USING(account_id)
WHERE t.status = 'completed' AND t.transaction_type = 'payment') > a.balance * 0.8;


-- Q.49 Medium 
-- Find all loans where the interest rate is above the average interest rate for that loan type. 
-- Show loan_id, loan_type, rate and average rate for that type.
SELECT 
l.loan_id,
l.loan_type,
  ROUND(l.interest_rate*100,2) as rate_pct,
	ROUND((SELECT 
    AVG(interest_rate) AS averageInterest
    FROM loans 
    WHERE loan_type = l.loan_type
    ) *100 ,2) AS averageInterest
FROM loans l 
WHERE interest_rate > (
SELECT 
ROUND(AVG(interest_rate),2) AS avg_interestRate
FROM loans 
WHERE loan_type = l.loan_type
);

-- Q.50 Medium
-- Find the top spending account in each state (highest total transaction amount). 
-- Show state, account_id, customer name and total spent.
WITH cte_total_spending_per_state AS(
SELECT 
account_id,
SUM(amount) AS total_spending,
state,
CONCAT(first_name,'_',last_name) AS full_name
FROM transactions t
JOIN accounts a USING(account_id)
JOIN customers USING(customer_id)
WHERE t.status = 'completed' AND t.transaction_type = 'payment'
GROUP BY a.account_id
),
 cte_rank_spending AS (SELECT 
*,
RANK() OVER(PARTITION BY state ORDER BY total_spending DESC) AS rank_spending_by_each_state
FROM cte_total_spending_per_state)
SELECT 
*
FROM cte_rank_spending
WHERE rank_spending_by_each_state = 1;
