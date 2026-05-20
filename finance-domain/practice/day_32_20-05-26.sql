-- Q.144
-- Show all credit card holders with their account balance and customer name.
-- Only show active credit cards.
EXPLAIN SELECT
c.card_id,
SUM(a.balance) AS total_balance
FROM cards c
JOIN accounts a USING(account_id)
WHERE c.status = 'active'
GROUP BY c.card_id;

CREATE INDEX indx_144 ON cards (status,account_id,card_id);
CREATE INDEX indx_144 ON accounts (account_id,balance);

-- Q.145
-- Find all cards that expire within the next 6 months.
-- Show card_id, card_type, last4, expiry_date and account_id.
EXPLAIN SELECT
c.card_id,
c.card_type,
c.card_number_last4,
c.expiry_date,
c.account_id
FROM cards c
WHERE c.expiry_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 6 MONTH);

CREATE INDEX indx_145 ON cards (expiry_date,card_id,card_type,card_number_last4,account_id);


-- Q.146
-- List all accounts opened in 2021.
-- Show account_id, customer_id, account_type, balance and opened_date.
EXPLAIN SELECT
a.account_id,
a.customer_id,
a.account_type,
a.balance,
a.opened_date
FROM accounts a
WHERE opened_date >= '2021-01-01' AND opened_date <= '2022-01-01';
CREATE INDEX indx_146 ON accounts (opened_date,account_id,customer_id,account_type,balance);

-- Q.147
-- Count how many cards exist for each card status (active, blocked, expired).
-- Show status and count.
EXPLAIN SELECT
c.status,
COUNT(CASE WHEN c.status = 'active' THEN 1 ELSE 0 END) AS total_count_active,
COUNT(CASE WHEN c.status = 'blocked' THEN 1 ELSE 0 END) AS total_count_blocked,
COUNT(CASE WHEN c.status = 'expired' THEN 1 ELSE 0 END) AS total_count_expired
FROM cards c
GROUP BY c.status;
CREATE INDEX indx_147 ON cards (status);


-- Q.148
-- Find all loan payments made in January 2024.
-- Show payment_id, loan_id, payment_date, amount_paid and remaining_balance.
EXPLAIN SELECT
lp.payment_id,
lp.loan_id,
lp.payment_date,
lp.amount_paid,
lp.remaining_balance
FROM loan_payments lp
WHERE lp.payment_date >= '2024-01-01' AND lp.payment_date < '2025-01-01';

CREATE INDEX indx_148 ON loan_payments (payment_date,payment_id,loan_id,amount_paid,remaining_balance);
