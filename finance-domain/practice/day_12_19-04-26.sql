-- Q.57 Easy
-- List all customers along with how many accounts they have. 
-- Include customers with ZERO accounts (they may have applied but not opened one yet).
SELECT 
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
COUNT(a.account_id) AS total_account,
CASE 
WHEN COUNT(a.account_id) = 0 THEN "applied but not opened one yet"
END 
FROM customers c 
LEFT JOIN accounts a USING(customer_id)
GROUP BY customer_id;


-- Q.58 Easy
-- Find all transactions where no merchant is recorded (merchant_id IS NULL). 
-- These represent internal transfers or ATM transactions.
SELECT 
t.transaction_id,
t.amount AS transaction_amount,
t.transaction_type
FROM transactions t 
WHERE merchant_id IS NULL AND t.status = 'completed';


-- Q.59 Easy
-- Show all cards. 
-- For credit cards show their credit limit; for debit/prepaid cards show "N/A" instead of NULL.
SELECT 
card_id,
card_type,
COALESCE(credit_limit,"N/A")
FROM cards 
ORDER BY credit_limit DESC;

-- Q.60 Medium 
-- Find all loans that are due to end (end_date) within the next 2 years from today. 
-- Show loan_id, customer_id, loan_type, end_date and outstanding_balance.
SELECT 
loan_id,
customer_id,
loan_type,
end_date,
outstanding_balance
FROM loans 
WHERE end_date <= DATE_ADD(curdate(),INTERVAL 2 YEAR);


-- Q.61 Medium 
-- Show all transactions from the last 30 days. 
-- Show transaction_id, type, amount, date and merchant name.
SELECT 
transaction_id,
t.transaction_type,
t.amount,
t.transaction_date,
m.name AS merchant_name 
FROM transactions t
LEFT JOIN merchants m USING(merchant_id)
WHERE t.transaction_date >= DATE_SUB(CURDATE(),INTERVAL 30 DAY);
