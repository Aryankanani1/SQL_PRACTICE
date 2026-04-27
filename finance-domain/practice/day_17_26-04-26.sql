-- Q.82 Medium
-- Find all loan types where the total interest rate paid (sum across all loan_payments)
-- exceeds $1,000. Show loan_type and total interest.
SELECT
l.loan_type,
SUM(lp.interest_paid) AS total_loan_payments
FROM loan_payments lp
JOIN loans l USING(loan_id)
GROUP BY l.loan_type
HAVING total_loan_payments > 1000;

-- Q.83 Medium
-- Using a CTE, identify customers who have a savings account but NO checking account.
-- These customers may need a checking account.
WITH cte_saving_accounts AS(
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
a.account_type
FROM accounts a
JOIN customers c USING(customer_id)
WHERE a.account_type = 'savings'
) , cte_for_checking_accounts AS (
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
a.account_type
FROM accounts a
JOIN customers c USING(customer_id)
WHERE a.account_type = 'checking'
)
SELECT
customer_id,
CONCAT(first_name,'_',last_name) AS full_name
FROM cte_saving_accounts
LEFT JOIN cte_for_checking_accounts USING(customer_id)
JOIN customers USING(customer_id)
WHERE customer_id IS NULL;


-- Q.84 Medium
-- Show each employee with their salary, their department average salary,
-- and how much above or below the department average they are.
SELECT
employee_id,
e.salary,
AVG(e.salary) OVER(PARTITION BY e.department) AS average_salary_by_department,
CASE
WHEN AVG(e.salary) OVER(PARTITION BY e.department) > e.salary THEN "below average"
ELSE 'above average'
END AS comparision,
e.department
FROM employees e;
