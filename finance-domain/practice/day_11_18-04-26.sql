-- Q.51 Easy
-- Show each card with its account balance and account type. 
-- Show card_id, card_type, card_number_last4, credit_limit, account_type and balance.
USE sql_finance;
SELECT 
c.card_id,
c.card_type,
c.card_number_last4,
c.credit_limit,
a.account_type,
a.balance
FROM cards c
JOIN accounts a USING(account_id);

-- Q.52 Easy
-- Show each employee with the name and city of their branch. 
-- Show employee full name, department, salary and branch info.
SELECT 
e.employee_id,
CONCAT(e.first_name,'_',e.last_name) AS full_name,
e.department,
e.salary,
branch_name,
b.city,
b.country
FROM branches b
JOIN employees e USING(branch_id);

-- Q.53 Easy
-- List all customers along with how many accounts they have. 
-- Include customers with ZERO accounts (they may have applied but not opened one yet).
SELECT 
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
COUNT(a.account_id) AS total_account,
CASE 
	WHEN COUNT(a.account_id) =0 then "they may have applied but not opened one yet"
    ELSE 'have an account'
    END AS 'not applied yet'
FROM customers c 
LEFT JOIN accounts a USING(customer_id)
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Q.54 Medium 
-- Using a CTE, show each loan with the percentage of the original principal that has been paid off. 
-- Show loan_id, loan_type, principal, outstanding_balance and pct_paid_off.
WITH cte_pct_paid_off AS
(
SELECT 
 loan_id,
 loan_type,
 principal_amount,
 outstanding_balance,
SUM((principal_amount - outstanding_balance) / principal_amount * 100) OVER(PARTITION BY loan_id) AS pct_paid_off
FROM loans 
WHERE status IN ('active','paid_off')
)
SELECT 
*,
ROUND(pct_paid_off,2) AS pct_paid_off
FROM cte_pct_paid_off
order BY pct_paid_off DESC;


-- Q.55 Medium 
-- Rank employees by salary within each department. 
-- Show employee name, department, salary, rank within department, and their salary percentile within the company.
WITH cte_rank_basedOn_salary_department AS(
SELECT 
e.employee_id,
e.department, 
e.salary,
RANK() OVER(PARTITION BY e.department ORDER BY e.salary DESC) AS rank_salary_on_department,
ROUND(PERCENT_RANK() OVER(ORDER BY salary) * 100 ,2) AS salary_percentile
FROM employees e 
)
SELECT 
e.employee_id,
CONCAT(e.first_name, '_', e.last_name) AS full_name,
e.department, 
e.salary,
rank_salary_on_department,
salary_percentile
FROM cte_rank_basedOn_salary_department 
JOIN employees e USING(employee_id)
WHERE rank_salary_on_department = 1;

-- Q.56 Medium 
-- Find merchant categories where the average transaction amount is above $100. 
-- Show category, avg transaction, total transactions and total volume.
SELECT 
m.merchant_id,
SUM(t.amount) AS total_volum,
ROUND(AVG(t.amount),2) AS avg_transaction_amount,
COUNT(transaction_id) AS total_transcation,
m.category AS merchant_category
FROM transactions t 
JOIN merchants m USING(merchant_id)
WHERE t.status = 'completed' AND t.transaction_type = 'payment'
GROUP BY m.category , m.merchant_id
HAVING avg_transaction_amount > 100
ORDER BY total_volum DESC;
