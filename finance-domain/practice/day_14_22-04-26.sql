-- Q.67 Easy
-- Show the total salary expense per department in the bank. 
-- Show department, employee count and total salary.
SELECT 
department,
COUNT(*) AS employee_count,
SUM(salary) AS total_salary
FROM employees 
GROUP BY department
ORDER BY total_salary DESC;

-- Q.68 Easy
-- Show each loan payment with the loan type and customer name. 
-- Show payment_id, payment_date, amount_paid, loan_type and customer full name.
SELECT 
CONCAT(first_name, '_',last_name) AS full_name,
payment_id,
payment_date,
amount_paid,
loan_type
FROM loan_payments 
JOIN loans USING(loan_id) 
JOIN customers USING(customer_id)
ORDER BY payment_date DESC;

-- Q.69 Medium 
-- Using a CTE, calculate each account's transaction count and total volume. 
-- Then classify accounts as "High", "Medium" or "Low" activity.
WITH cte_Account_report AS (
SELECT 
a.account_id,
SUM(t.amount) AS total_volume,
COUNT(t.transaction_id) AS transaction_count
FROM accounts a 
JOIN transactions t USING(account_id) 
WHERE t.status = 'completed' 
GROUP BY a.account_id
) SELECT 
account_id,
coalesce(transaction_count,0) AS transaction_volum,
coalesce(total_volume,0) AS total_volum,
CASE 
 WHEN transaction_count >= 5 then 'High'
 WHEN transaction_count >= 3 then 'Medium'
 WHEN transaction_count >= 1 then 'low'
 ELSE 'Dormant'
 END AS activity_segment
FROM accounts 
LEFT JOIN cte_Account_report USING(account_id);


-- Q.70 Medium 
-- Find customers who have NEVER missed a loan payment 
-- (i.e., none of their loans are in delinquent or defaulted status).
SELECT 
customer_id,
CONCAT(first_name,'_',last_name) AS full_name,
loan_type
FROM customers c 
JOIN loans l USING(customer_id) 
WHERE customer_id NOT IN (
SELECT 
customer_id
FROM loans 
WHERE status IN('delinquent')
);


-- Q.71 Medium 
-- Which loan types have an average outstanding 
-- balance above $100,000 AND more than 1 loan in that category?
SELECT 
loan_type,
ROUND(AVG(outstanding_balance),2) AS average_outstanding,
COUNT(*) AS total_loanCount
FROM loans
WHERE status = 'active'
GROUP BY loan_type 
HAVING average_outstanding > 100000 AND total_loanCount > 1;
