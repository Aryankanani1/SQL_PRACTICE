-- Q.43 Easy
-- Find the average, minimum and maximum loan amount (principal) for each loan type.
SELECT 
loan_type,
AVG(principal_amount) AS avg_principal_amount,
MIN(principal_amount) AS minimum_amount,
MAX(principal_amount) AS max_amount
FROM loans
GROUP BY loan_type
ORDER BY avg_principal_amount;

-- Q.44 Easy 
-- Show each account with the full name of its customer. 
-- Display account_id, account_type, balance and customer full name.
SELECT 
account_id,
account_type,
balance,
CONCAT(c.first_name, '_', c.last_name) AS full_name
FROM customers c 
JOIN accounts a USING(customer_id);


-- Q.45 Medium
-- Using a CTE, calculate the debt-to-income ratio (total outstanding loans / total account balance) for each customer. 
-- Show customers where this ratio exceeds 2.0.
WITH cte_total_outstanding_balance AS
(SELECT 
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
SUM(l.outstanding_balance) AS total_outstanding_balance
FROM loans l
JOIN customers c USING(customer_id)
WHERE status = 'active'
GROUP BY customer_id), cte_total_account_balance AS 
(SELECT 
c.customer_id,
CONCAT(c.first_name,'_', c.last_name) AS full_name,
SUM(a.balance) AS total_balance
FROM accounts a 
JOIN customers c USING(customer_id) 
WHERE status = 'active'
GROUP BY customer_id)
SELECT 
customer_id,
first_name,
ROUND(total_outstanding_balance/total_balance) AS debt_to_income_ration
FROM cte_total_outstanding_balance 
JOIN cte_total_account_balance USING(customer_id)
JOIN customers USING(customer_id)
WHERE total_outstanding_balance/NULLIF(total_balance,0) > 2.0;

-- Q.46 Medium 
-- List all customers who have at least one account in EACH of these types: checking AND savings. 
-- These are well-diversified customers.
SELECT
  CONCAT(c.first_name,' ',c.last_name) AS customer,
  c.email
FROM customers c
WHERE EXISTS (
  SELECT 1 FROM accounts a
  WHERE a.customer_id = c.customer_id
    AND a.account_type = 'checking'
    AND a.status = 'active'
)
AND EXISTS (
  SELECT 1 FROM accounts a
  WHERE a.customer_id = c.customer_id
    AND a.account_type = 'savings'
    AND a.status = 'active'
)
ORDER BY c.last_name;
