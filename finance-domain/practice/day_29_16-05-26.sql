-- Q.132
-- Count how many loans each customer has.
-- Show customer_id, customer full name and loan count. Only show customers with at least 1 loan.
EXPLAIN SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
COUNT(l.loan_id) AS loan_count
FROM customers c
JOIN loans l USING(customer_id)
WHERE l.status = 'active'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY c.customer_id;

-- Optimization
CREATE INDEX indx_status_customer_Id ON loans (status,customer_id);

EXPLAIN SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
agg.totalActive_loan
FROM customers c
JOIN (
SELECT
        customer_id,
        COUNT(*) AS totalActive_loan
        FROM loans
        WHERE status = 'active'
        GROUP BY customer_id
) agg ON c.customer_id = agg.customer_id
ORDER BY customer_id;

-- Q.133
-- List all mortgage loans. Show loan_id, customer_id, principal_amount, interest_rate and monthly_payment.
EXPLAIN SELECT
loan_id,
customer_id,
principal_amount,
interest_rate,
monthly_payment
FROM loans
WHERE loan_type = 'mortgage';

CREATE INDEX idx_loan_type ON loans (loan_type);

-- Q.134
-- What is the average transaction amount by transaction type for completed transactions?
CREATE INDEX idx_status_transaction_type_amount ON transactions (status,transaction_type,amount);
EXPLAIN SELECT
t.transaction_type,
ROUND(AVG(t.amount),2) AS average_amount
FROM transactions t
WHERE status = 'completed'
GROUP BY t.transaction_type;


-- Q.135
-- Show all active accounts with their customer's KYC status.
-- Highlight accounts where KYC is not complete.
EXPLAIN SELECT
a.account_id,
c.kyc_verified,
CASE
WHEN kyc_verified = 1 THEN 'verified'
ELSE 'not verified'
END AS kyc_status
FROM customers c
JOIN accounts a USING (customer_id)
WHERE a.status = 'active';
