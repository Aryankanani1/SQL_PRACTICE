-- subquery
-- Q.1 Find all accounts whose balance is above the overall average balance across all active accounts.
SELECT
account_id,
balance,
account_type
FROM accounts a
WHERE balance >
(SELECT
AVG(balance)
FROM accounts
WHERE status = 'active'
) AND status = 'active';

-- Q.2 Show all employees who earn more than the average salary of the entire company.
-- Show name, department and salary.
SELECT
CONCAT(e.first_name,'_',e.last_name) AS full_name,
e.department,
e.salary
FROM employees e
WHERE e.salary > (
SELECT
AVG(salary)
FROM employees
);


-- Q.3
-- Find all loans where the interest rate is higher than the average interest rate across all active loans.
SELECT
l.loan_id,
l.loan_type,
ROUND(l.interest_rate*100 ,2)
FROM loans l
WHERE interest_rate > (
SELECT
AVG(interest_rate)
FROM loans
WHERE status = 'active'
) AND l.status = 'active';


-- Q.4
-- Find the customer who holds the single highest account balance.
-- Show their full name and balance.
SELECT
account_id,
balance AS highest_balance,
CONCAT(c.first_name,'_',c.last_name) AS full_name
FROM accounts a
JOIN customers c USING(customer_id)
WHERE a.balance = (SELECT
MAX(balance) FROM
accounts);

-- Q.5
-- Show all transactions whose amount is greater than the average
-- transaction amount for ALL completed transactions.
SELECT
t.transaction_id,
t.amount
FROM transactions t
WHERE t.amount > (
SELECT
AVG(amount)
FROM transactions
WHERE status = 'completed'
) AND t.status = 'completed';

-- Q.6
-- Find all customers who have at least one loan. Use IN -- do not use a JOIN.
SELECT
c.customer_id,
CONCAT(c.first_name,'_', c.last_name) AS full_name,
l.loan_type,
l.principal_amount
FROM loans l
JOIN customers c USING(customer_id)
WHERE c.customer_id IN(SELECT
customer_id
FROM loans
WHERE status = 'active'
);

-- Q.7
-- Find all customers who have NO loans at all. Use NOT IN.
SELECT
c.customer_id,
CONCAT(c.first_name,'_',c.last_name) AS full_name,
l.loan_type,
l.principal_amount
FROM loans l
JOIN customers c USING(customer_id)
WHERE c.customer_id NOT IN (
SELECT
DISTINCT customer_id
FROM loans
);
