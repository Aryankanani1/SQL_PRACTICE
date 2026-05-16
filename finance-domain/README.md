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

| Day | Date | File | Difficulty | Topics |
|-----|------|------|------------|--------|
| 1 | 7/4/26 | [day_01_07-04-26.sql](practice/day_01_07-04-26.sql) | Easy / Medium / Hard | WHERE, YEAR(), GROUP BY, HAVING, JOIN, CTE, ROW_NUMBER() |
| 2 | 8/4/26 | [day_02_08-04-26.sql](practice/day_02_08-04-26.sql) | Easy / Medium / Hard | WHERE, Window Functions, Running Total, CASE, CTE, DENSE_RANK() |
| 3 | 9/4/26 | [day_03_09-04-26.sql](practice/day_03_09-04-26.sql) | Easy / Medium / Hard | WHERE, LAG(), NULLIF(), DENSE_RANK(), CTE, Loan Amortization |
| 4 | 10/4/26 | [day_04_10-04-26.sql](practice/day_04_10-04-26.sql) | Easy / Medium | SUM(), AVG(), COUNT(), GROUP BY, Multi-CTE, Debt vs Balance analysis |
| 5 | 11/4/26 | [day_05_11-04-26.sql](practice/day_05_11-04-26.sql) | Hard | Multi-CTE, NULLIF(), Month-over-month analysis, Fraud detection, ROW_NUMBER() |
| 6 | 12/4/26 | [day_06_12-04-26.sql](practice/day_06_12-04-26.sql) | Easy / Medium | JOIN, SUM(), Correlated Subquery, MAX(), ROW_NUMBER(), CASE |
| 7 | 13/4/26 | [day_07_13-04-26.sql](practice/day_07_13-04-26.sql) | Easy / Medium | GROUP BY, HAVING, COUNT(), NOT IN subquery, Correlated subquery |
| 8 | 14/4/26 | [day_08_14-04-26.sql](practice/day_08_14-04-26.sql) | Medium | HAVING, CTE, Correlated subquery, RANK() OVER PARTITION, multi-loan type filter |
| 9 | 15/4/26 | [day_09_15-04-26.sql](practice/day_09_15-04-26.sql) | Easy / Medium | AVG/MIN/MAX, JOIN, Multi-CTE, NULLIF(), EXISTS subquery, debt-to-income ratio |
| 10 | 16/4/26 | [day_10_16-04-26.sql](practice/day_10_16-04-26.sql) | Easy / Medium | LEFT JOIN, Correlated subquery, RANK() OVER PARTITION BY state, Multi-CTE |
| 11 | 18/4/26 | [day_11_18-04-26.sql](practice/day_11_18-04-26.sql) | Easy / Medium | JOIN, LEFT JOIN, CASE, CTE, RANK(), PERCENT_RANK(), HAVING |
| 12 | 19/4/26 | [day_12_19-04-26.sql](practice/day_12_19-04-26.sql) | Easy / Medium | LEFT JOIN, IS NULL, COALESCE(), DATE_ADD(), DATE_SUB(), CURDATE() |
| 13 | 21/4/26 | [day_13_21-04-26.sql](practice/day_13_21-04-26.sql) | Easy / Medium | JOIN, Multi-CTE, Churn analysis, Moving average, COUNT(DISTINCT), HAVING |
| 14 | 22/4/26 | [day_14_22-04-26.sql](practice/day_14_22-04-26.sql) | Easy / Medium | GROUP BY, JOIN, CTE, COALESCE(), CASE, NOT IN subquery, HAVING |
| 15 | 23/4/26 | [day_15_23-04-26.sql](practice/day_15_23-04-26.sql) | Medium | CTE + outlier detection, Correlated subquery, ROW_NUMBER(), TIMESTAMPDIFF(), NULLIF() |
| 16 | 24/4/26 | [day_16_24-04-26.sql](practice/day_16_24-04-26.sql) | Medium | HAVING, Correlated subquery, CTE + ROW_NUMBER(), LEAD(), Cumulative % with ROWS UNBOUNDED |
| 17 | 26/4/26 | [day_17_26-04-26.sql](practice/day_17_26-04-26.sql) | Medium | HAVING, Multi-CTE + LEFT JOIN gap analysis, Window AVG + CASE |
| 18 | 28/4/26 | [day_18_28-04-26.sql](practice/day_18_28-04-26.sql) | Medium | Multi-CTE spend %, LAG() + DATEDIFF(), derived table JOIN, CTE + LEFT JOIN null filter |
| 19 | 30/4/26 | [day_19_30-04-26.sql](practice/day_19_30-04-26.sql) | Medium | ROW_NUMBER() top-N per dept, CTE + window AVG % diff, HAVING 5x balance multiplier |
| 20 | 2/5/26 | [day_20_02-05-26.sql](practice/day_20_02-05-26.sql) | Easy / Medium | CTE + LAG() MoM change, HAVING vs subquery avg, CASE net flow, window SUM % of monthly total |
| 21 | 5/5/26 | [day_21_05-05-26.sql](practice/day_21_05-05-26.sql) | Medium | TIMESTAMPDIFF avg deposit, ALL operator, CTE cash flow + CASE, nested subquery avg tx, DENSE_RANK() 2nd highest |
| 22 | 6/5/26 | [day_22_06-05-26.sql](practice/day_22_06-05-26.sql) | Medium | GROUP BY monthly interest, ROW_NUMBER() top-2 per account, NULLIF % HAVING, CTE CASE net flow, Multi-CTE low-engagement filter |
| 23 | 7/5/26 | [day_23_07-05-26.sql](practice/day_23_07-05-26.sql) | Medium | Multi-CTE loan completion %, HAVING branch salary, Multi-CTE net worth RANK(), window SUM % of type, CTE top-5 tx per account |
| 24 | 9/5/26 | [day_24_09-05-26.sql](practice/day_24_09-05-26.sql) | Medium | Self-join peer comparison, Multi-CTE + DATEDIFF within 3 days, NTILE(3) tier labels, HAVING MAX/MIN disparity, Multi-CTE portfolio upgrade, GROUP_CONCAT distinct types |
| 25 | 10/5/26 | [day_25_10-05-26.sql](practice/day_25_10-05-26.sql) | Hard | Multi-CTE ROW_NUMBER() peak spending month, RANGE INTERVAL 30-day rolling AVG, Multi-CTE delinquent + balance risk filter |
| 26 | 11/5/26 | [day_26_11-05-26.sql](practice/day_26_11-05-26.sql) | Hard | Window STDDEV statistical outlier detection, Multi-CTE + RANK() burst activity fraud detection |
| 27 | 12/5/26 | [day_27_12-05-26.sql](practice/day_27_12-05-26.sql) | Hard | Double EXISTS financially stressed filter, Running SUM ROWS UNBOUNDED cumulative interest, Self-join same-day duplicate/fraud detection, Multi-CTE health score + DENSE_RANK() |
| 28 | 15/5/26 | [day_28_15-05-26.sql](practice/day_28_15-05-26.sql) | Medium | CREATE INDEX, EXPLAIN, range filter vs YEAR() wrap, FORCE INDEX, index range wall, derived table JOIN optimization |
| 29 | 16/5/26 | [day_29_16-05-26.sql](practice/day_29_16-05-26.sql) | Medium | EXPLAIN + derived table JOIN optimization, composite index on loans, index on loan_type, covering index AVG, JOIN + CASE KYC status |

### Subquery Practice (`subquery_practice/`)

| Day | Date | File | Difficulty | Topics |
|-----|------|------|------------|--------|
| 1 | 25/4/26 | [day_01_25-04-26.sql](subquery_practice/day_01_25-04-26.sql) | Easy / Medium | Scalar subquery, IN, NOT IN, MAX/AVG subquery |
| 2 | 26/4/26 | [day_02_26-04-26.sql](subquery_practice/day_02_26-04-26.sql) | Easy / Medium | IN, NOT IN, EXISTS, NOT EXISTS |
| 3 | 27/4/26 | [day_03_27-04-26.sql](subquery_practice/day_03_27-04-26.sql) | Medium | NOT EXISTS, Scalar subquery, Derived table, Correlated subquery, double IN |
| 4 | 28/4/26 | [day_04_28-04-26.sql](subquery_practice/day_04_28-04-26.sql) | Medium | Derived table + LIMIT, Scalar subquery, IN with HAVING, AVG subquery |
| 5 | 29/4/26 | [day_05_29-04-26.sql](subquery_practice/day_05_29-04-26.sql) | Medium | Double EXISTS, correlated subquery, derived table vs correlated (2 ways each), CTE + recent tx |
| 6 | 2/5/26 | [day_06_02-05-26.sql](subquery_practice/day_06_02-05-26.sql) | Medium | EXISTS + NOT EXISTS, correlated SELECT, ALL operator, double IN months filter, derived table payroll |
| 7 | 4/5/26 | [day_07_04-05-26.sql](subquery_practice/day_07_04-05-26.sql) | Medium | EXISTS + frozen/delinquent filter, derived table MoM self-join, correlated subquery interest % |
