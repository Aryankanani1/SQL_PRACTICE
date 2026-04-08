-- Q.7 Easy 
-- List all customers who have NOT completed KYC verification (kyc_verified = 0). 
-- Show their full name, email, and state.
USE sql_finance;
SELECT 
CONCAT(first_name, '_',last_name) AS full_name,
email,
state
FROM customers 
WHERE kyc_verified = 0;

-- Q.8 Easy
-- Find all credit cards that are currently active and have a credit limit above $5,000. 
-- Show card_id, card_number_last4, credit_limit and expiry_date.
USE sql_finance;
SELECT 
card_id,
card_number_last4,
credit_limit,
expiry_date
FROM cards 
WHERE status = 'active' AND credit_limit > 5000 AND card_type = 'credit';

-- Q.9 Easy 
-- List all loans that are currently in "delinquent" or "defaulted" status.
-- Show loan_id, customer_id, loan_type, outstanding_balance and status.
SELECT 
loan_id,
customer_id,
loan_type,
outstanding_balance,
status AS loan_status
FROM loans 
WHERE status IN ('delinquent','defaulted')
ORDER BY outstanding_balance DESC;

-- Q.10 Medium 
-- Show a running total of loan payments for each loan. 
-- For each payment show the loan_id, payment date, amount paid and cumulative total paid so far.
SELECT 
loan_id,
payment_date,
amount_paid,
SUM(amount_paid) OVER(PARTITION BY loan_id ORDER BY payment_date 
ROWS BETWEEN UNBOUNDED preceding AND CURRENT ROW) AS cumulative_total
FROM loan_payments;


-- Q.11 Medium 
-- For each account, show each transaction with the running balance (starting from 0, add deposits, subtract withdrawals and payments). 
-- Show account_id, date, type, amount and running balance.
SELECT 
t.account_id,
t.transaction_date,
t.transaction_type,
t.amount,
SUM(
CASE 
	WHEN transaction_type IN ('deposit','refund') THEN t.amount 
    ELSE -(t.amount)
    END
) OVER(PARTITION BY account_id ORDER BY t.transaction_date
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_balance
FROM transactions t
WHERE status = 'completed'
ORDER BY account_id,t.transaction_date;

-- Q.12 Hard 
-- Build a customer lifetime value (LTV) report: for each customer show total spend, average monthly spend, 
-- months active, and rank by LTV. Use CTEs.
WITH cte_for_total_spend AS(
SELECT 
c.customer_id,
CONCAT(c.first_name ,'_', last_name) AS full_name,
MONTHNAME(t.transaction_date) month_name,
SUM(t.amount) AS total_spend
FROM customers c 
JOIN accounts a USING(customer_id)
JOIN transactions t USING(account_id)
WHERE t.status = 'completed' 
AND t.transaction_type IN ('payment')
GROUP BY c.customer_id, c.first_name , c.last_name, month_name
), cte_customer_stats AS(
SELECT 
customer_id,
SUM(total_spend) AS lifetime_spend,
AVG(total_spend) AS avg_monthly_spend
FROM cte_for_total_spend
GROUP BY customer_id
)
SELECT 
dense_rank() OVER(ORDER BY lifetime_spend DESC) AS rank_by_ltv,
lifetime_spend,
ROUND(avg_monthly_spend,2)
FROM cte_customer_stats
JOIN customers USING(customer_id)
ORDER BY rank_by_ltv;
