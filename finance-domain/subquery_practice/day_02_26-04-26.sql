-- Subqueries
-- Q.8
-- Find all accounts that have had at least one FAILED transaction. Use IN.
SELECT
t.account_id,
t.amount,
t.transaction_type,
t.status
FROM transactions t
WHERE t.status IN (
SELECT
t.account_id
FROM transactions
WHERE t.status = 'failed'
);

-- Q.9
-- Find all merchants that have NEVER received a payment transaction. Use NOT IN.
SELECT
m.merchant_id,
m.name AS merchant_name
FROM merchants m
WHERE m.merchant_id NOT IN
(SELECT
t.merchant_id
FROM transactions t
WHERE t.transaction_type = 'payment'
AND merchant_id IS NOT NULL
);

-- Q.10
-- Find all customers who live in states that have at least one bank branch. Use IN.
SELECT
customer_id,
CONCAT(first_name,'_',last_name) AS full_name,
state
FROM customers
WHERE state IN (
SELECT
state
FROM branches
);

-- Q.11
-- Find all customers who have at least one ACTIVE account. Use EXISTS.
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name
FROM customers c
WHERE EXISTS (
SELECT
1
FROM accounts
WHERE customer_id = c.customer_id AND status = 'active'
);

-- Q.12
-- Find all customers who has no active account
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
status
FROM customers c
JOIN accounts USING(customer_id)
WHERE NOT EXISTS(
SELECT
1
FROM accounts
WHERE customer_id = c.customer_id AND status = 'active'
);


-- Q.13
-- Find all loans that have at least one payment recorded. Use EXISTS.
SELECT
l.loan_id,
l.loan_type,
l.outstanding_balance,
l.monthly_payment,
lp.interest_paid,
lp.remaining_balance,
lp.payment_date
FROM loans l
JOIN loan_payments lp USING(loan_id)
WHERE EXISTS
(
SELECT
1
FROM loan_payments
WHERE loan_id = l.loan_id
);
