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

### General Practice (`practice/`)

| Day | File | Difficulty | Topics |
|-----|------|------------|--------|
| 1 | [day_01_07-04-26.sql](practice/day_01_07-04-26.sql) | Easy / Medium / Hard | WHERE, YEAR(), GROUP BY, HAVING, JOIN, CTE, ROW_NUMBER() |
| 2 | [day_02_08-04-26.sql](practice/day_02_08-04-26.sql) | Easy / Medium / Hard | WHERE, Window Functions, Running Total, CASE, CTE, DENSE_RANK() |
| 3 | [day_03_09-04-26.sql](practice/day_03_09-04-26.sql) | Easy / Medium / Hard | WHERE, LAG(), NULLIF(), DENSE_RANK(), CTE, Loan Amortization |
| 4 | [day_04_10-04-26.sql](practice/day_04_10-04-26.sql) | Easy / Medium | SUM(), AVG(), COUNT(), GROUP BY, Multi-CTE, Debt vs Balance analysis |
| 5 | [day_05_11-04-26.sql](practice/day_05_11-04-26.sql) | Hard | Multi-CTE, NULLIF(), Month-over-month analysis, Fraud detection, ROW_NUMBER() |
| 6 | [day_06_12-04-26.sql](practice/day_06_12-04-26.sql) | Easy / Medium | JOIN, SUM(), Correlated Subquery, MAX(), ROW_NUMBER(), CASE |
| 7 | [day_07_13-04-26.sql](practice/day_07_13-04-26.sql) | Easy / Medium | GROUP BY, HAVING, COUNT(), NOT IN subquery, Correlated subquery |
| 8 | [day_08_14-04-26.sql](practice/day_08_14-04-26.sql) | Medium | HAVING, CTE, Correlated subquery, RANK() OVER PARTITION, multi-loan type filter |
| 9 | [day_09_15-04-26.sql](practice/day_09_15-04-26.sql) | Easy / Medium | AVG/MIN/MAX, JOIN, Multi-CTE, NULLIF(), EXISTS subquery, debt-to-income ratio |
| 10 | [day_10_16-04-26.sql](practice/day_10_16-04-26.sql) | Easy / Medium | LEFT JOIN, Correlated subquery, RANK() OVER PARTITION BY state, Multi-CTE |
| 11 | [day_11_18-04-26.sql](practice/day_11_18-04-26.sql) | Easy / Medium | JOIN, LEFT JOIN, CASE, CTE, RANK(), PERCENT_RANK(), HAVING |
| 12 | [day_12_19-04-26.sql](practice/day_12_19-04-26.sql) | Easy / Medium | LEFT JOIN, IS NULL, COALESCE(), DATE_ADD(), DATE_SUB(), CURDATE() |
| 13 | [day_13_21-04-26.sql](practice/day_13_21-04-26.sql) | Easy / Medium | JOIN, Multi-CTE, Churn analysis, Moving average, COUNT(DISTINCT), HAVING |
| 14 | [day_14_22-04-26.sql](practice/day_14_22-04-26.sql) | Easy / Medium | GROUP BY, JOIN, CTE, COALESCE(), CASE, NOT IN subquery, HAVING |
| 15 | [day_15_23-04-26.sql](practice/day_15_23-04-26.sql) | Medium | CTE + outlier detection, Correlated subquery, ROW_NUMBER(), TIMESTAMPDIFF(), NULLIF() |
| 16 | [day_16_24-04-26.sql](practice/day_16_24-04-26.sql) | Medium | HAVING, Correlated subquery, CTE + ROW_NUMBER(), LEAD(), Cumulative % with ROWS UNBOUNDED |
| 17 | [day_17_26-04-26.sql](practice/day_17_26-04-26.sql) | Medium | HAVING, Multi-CTE + LEFT JOIN gap analysis, Window AVG + CASE |
| 18 | [day_18_28-04-26.sql](practice/day_18_28-04-26.sql) | Medium | Multi-CTE spend %, LAG() + DATEDIFF(), derived table JOIN, CTE + LEFT JOIN null filter |
| 19 | [day_19_30-04-26.sql](practice/day_19_30-04-26.sql) | Medium | ROW_NUMBER() top-N per dept, CTE + window AVG % diff, HAVING 5x balance multiplier |
| 20 | [day_20_02-05-26.sql](practice/day_20_02-05-26.sql) | Easy / Medium | CTE + LAG() MoM change, HAVING vs subquery avg, CASE net flow, window SUM % of monthly total |

### Subquery Practice (`subquery_practice/`)

| Day | File | Difficulty | Topics |
|-----|------|------------|--------|
| 1 | [day_01_25-04-26.sql](subquery_practice/day_01_25-04-26.sql) | Easy / Medium | Scalar subquery, IN, NOT IN, MAX/AVG subquery |
| 2 | [day_02_26-04-26.sql](subquery_practice/day_02_26-04-26.sql) | Easy / Medium | IN, NOT IN, EXISTS, NOT EXISTS |
| 3 | [day_03_27-04-26.sql](subquery_practice/day_03_27-04-26.sql) | Medium | NOT EXISTS, Scalar subquery, Derived table, Correlated subquery, double IN |
| 4 | [day_04_28-04-26.sql](subquery_practice/day_04_28-04-26.sql) | Medium | Derived table + LIMIT, Scalar subquery, IN with HAVING, AVG subquery |
| 5 | [day_05_29-04-26.sql](subquery_practice/day_05_29-04-26.sql) | Medium | Double EXISTS, correlated subquery, derived table vs correlated (2 ways each), CTE + recent tx |
| 6 | [day_06_02-05-26.sql](subquery_practice/day_06_02-05-26.sql) | Medium | EXISTS + NOT EXISTS, correlated SELECT, ALL operator, double IN months filter, derived table payroll |
