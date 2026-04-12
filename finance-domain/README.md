# Finance Domain — SQL Practice

Daily SQL problems set in a finance context: banking, transactions, accounts, loans, and more.

## Setup
Run [finance_db_setup.sql](finance-domain-db/finance_db_setup.sql) to create the database, tables, and seed data.
Mimics real banking systems used at JPMorgan, Goldman, Stripe, PayPal, Visa.

**Tables:** `customers`, `accounts`, `transactions`, `loans`, `loan_payments`, `merchants`, `cards`, `branches`, `employees`

## Topics Covered
- Aggregations & GROUP BY
- JOINs (INNER, LEFT, SELF)
- Window Functions (RANK, ROW_NUMBER, LAG/LEAD)
- Subqueries & CTEs
- Date/Time operations
- Filtering & CASE expressions

## Problems

| Day | File | Difficulty | Topics |
|-----|------|------------|--------|
| 1 | [day_01_07-04-26.sql](practice/day_01_07-04-26.sql) | Easy / Medium / Hard | WHERE, YEAR(), GROUP BY, HAVING, JOIN, CTE, ROW_NUMBER() |
| 2 | [day_02_08-04-26.sql](practice/day_02_08-04-26.sql) | Easy / Medium / Hard | WHERE, Window Functions, Running Total, CASE, CTE, DENSE_RANK() |
| 3 | [day_03_09-04-26.sql](practice/day_03_09-04-26.sql) | Easy / Medium / Hard | WHERE, LAG(), NULLIF(), DENSE_RANK(), CTE, Loan Amortization |
| 4 | [day_04_10-04-26.sql](practice/day_04_10-04-26.sql) | Easy / Medium | SUM(), AVG(), COUNT(), GROUP BY, Multi-CTE, Debt vs Balance analysis |
| 5 | [day_05_11-04-26.sql](practice/day_05_11-04-26.sql) | Hard | Multi-CTE, NULLIF(), Month-over-month analysis, Fraud detection, ROW_NUMBER() |
| 6 | [day_06_12-04-26.sql](practice/day_06_12-04-26.sql) | Easy / Medium | JOIN, SUM(), Correlated Subquery, MAX(), ROW_NUMBER(), CASE |
