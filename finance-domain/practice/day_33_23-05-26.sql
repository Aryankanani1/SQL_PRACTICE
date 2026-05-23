-- Q.149
-- Show each branch with the number of employees working there.
-- Show branch name, city and employee count.
USE sql_finance;
EXPLAIN SELECT
b.name AS branch_name,
b.city,
agg.total_employee
FROM branches b
JOIN (
SELECT
branch_id,
COUNT(*) AS total_employee
FROM employees
GROUP BY branch_id
) agg ON b.branch_id = agg.branch_id;
CREATE INDEX indx_149 ON branches (branch_id,name,city);

-- Q.150
-- List all merchants that are currently inactive (is_active = 0).
-- Show merchant_id, merchant_name and category.
EXPLAIN SELECT
merchant_id,
name AS merchant_name,
category
FROM merchants
WHERE is_active = 0
ORDER BY merchant_id;

CREATE INDEX indx_150 ON merchants (is_active,merchant_id,name,category);

-- Q.151
-- What is the total outstanding balance across ALL loans grouped by loan status?
-- Show status, count and total balance.
EXPLAIN SELECT
status,
COUNT(*) AS count_,
SUM(outstanding_balance) AS total_balance
FROM loans
GROUP BY status
ORDER BY SUM(outstanding_balance);

CREATE INDEX indx_151 ON loans (status,outstanding_balance);

-- Q.152
-- Find all customers who do NOT have a phone number on file.
-- Show customer_id, full name and email.
EXPLAIN SELECT
customer_id,
CONCAT(first_name,'_',last_name) AS full_name,
email
FROM customers
WHERE phone IS NULL;

CREATE INDEX indx_152 ON customers (phone,customer_id,first_name,last_name,email);


-- Q.153
-- Find all employees who have been with the company for more than 5 years.
-- Show their full name, department, hire_date and years of service.
EXPLAIN SELECT
CONCAT(first_name,'_',last_name) AS full_name,
department,
hire_date
FROM employees
WHERE hire_date <= DATE_SUB(CURDATE(),INTERVAL 5 YEAR);
CREATE INDEX indx_153 ON employees (hire_date,first_name,last_name,department);
