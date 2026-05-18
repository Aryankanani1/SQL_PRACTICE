-- Q.136
-- List all customers who have been with the bank for more than 3 years.
-- Show full name, created_at, and how many years they have been a customer.
USE sql_finance;
CREATE INDEX indx_created_at_firstName_lastName ON customers (created_at,first_name,last_name);
EXPLAIN SELECT
CONCAT(c.first_name,'_',c.last_name) AS full_name,
c.created_at,
TIMESTAMPDIFF(year, c.created_at , curdate()) AS years
FROM customers c
WHERE c.created_at <= DATE_SUB(CURDATE(),INTERVAL 3 YEAR)
ORDER BY c.created_at DESC;


-- Q.137
-- Find all personal or student loans under $50,000 in outstanding balance.
-- Show loan details and status.
-- (before optimization cost is 0.7)
-- (after optimization cost is 0.6)
CREATE INDEX indx_all
ON loans (status,loan_type,loan_id,principal_amount,outstanding_balance,interest_rate);
EXPLAIN SELECT
loan_id,
loan_type,
principal_amount,
outstanding_balance,
interest_rate,
status
FROM loans
WHERE status = 'active' AND loan_type IN ('student','personal');

-- Q.138
-- What is the total interest paid on each loan?
-- Show loan_id, loan_type and total interest paid from loan_payments.
-- 1. Create the optimal index on the payments table instead
CREATE INDEX idx_payments_loan_id_interest ON loan_payments (loan_id, interest_paid);
EXPLAIN SELECT
    l.loan_id,
    l.loan_type,
    agg.total_interest_paid
FROM loans l
JOIN (
    SELECT
        loan_id,
        SUM(interest_paid) AS total_interest_paid
    FROM loan_payments
    GROUP BY loan_id
) agg ON l.loan_id = agg.loan_id
ORDER BY l.loan_id;

-- Q.139
-- Show each employee and their manager's name.
-- Include employees with no manager (the top level).
-- Show employee name, department, salary and manager name.
EXPLAIN SELECT
e.employee_id,
CONCAT(e.first_name,'_',e.last_name) AS employe_name,
e.department,
e.salary,
e.reports_to
FROM employees e
LEFT JOIN employees e1 ON e.reports_to = e1.employee_id;

-- Q.140
-- Find all loan payments where the remaining balance after payment is less than $1,000.
-- These loans are nearly paid off.
EXPLAIN SELECT
  lp.payment_id,
  lp.loan_id,
  l.loan_type,
  lp.payment_date,
  lp.amount_paid,
  lp.remaining_balance
FROM loan_payments lp FORCE INDEX(indx_140_1)
JOIN loans l USING(loan_id)
WHERE lp.remaining_balance < 10000
ORDER BY remaining_balance ASC;
CREATE INDEX indx_140_1 ON loan_payments (remaining_balance,loan_id);
