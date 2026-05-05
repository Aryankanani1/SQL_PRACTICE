# SQL_PRACTICE — Project Summary

## Purpose
Daily SQL problem-solving portfolio for interview prep and resume. Aryan solves questions, shares the `.sql` file, and Claude commits + pushes to GitHub.

## GitHub
- Repo: https://github.com/Aryankanani1/SQL_PRACTICE (public)
- Git email: aryankanani57@gmail.com (verified on Aryankanani1 account)

## Folder Structure
```
SQL_PRACTICE/
├── README.md
└── finance-domain/
    ├── README.md                        ← problems table, updated each day
    ├── finance-domain-db/
    │   └── finance_db_setup.sql        ← MySQL schema + seed data
    ├── subquery_practice/
    │   ├── day_01_25-04-26.sql         ← Q1–Q7 (subquery series)
    │   ├── day_02_26-04-26.sql         ← Q8–Q13 (subquery series)
    │   ├── day_03_27-04-26.sql         ← Q14–Q19 (subquery series)
    │   ├── day_04_28-04-26.sql         ← Q20–Q24 (subquery series)
    │   ├── day_05_29-04-26.sql         ← Q25–Q29 (subquery series)
    │   ├── day_06_02-05-26.sql         ← Q30–Q35 (subquery series)
    │   └── day_07_04-05-26.sql         ← Q36–Q38 (subquery series)
    └── practice/
        ├── day_01_07-04-26.sql         ← Q1–Q6
        ├── day_02_08-04-26.sql         ← Q7–Q12
        ├── day_03_09-04-26.sql         ← Q13–Q18
        ├── day_04_10-04-26.sql         ← Q19–Q23
        ├── day_05_11-04-26.sql         ← Q24–Q25
        ├── day_06_12-04-26.sql         ← Q27–Q32
        ├── day_07_13-04-26.sql         ← Q33–Q37
        ├── day_08_14-04-26.sql         ← Q38–Q42
        ├── day_09_15-04-26.sql         ← Q43–Q46
        ├── day_10_16-04-26.sql         ← Q47–Q50
        ├── day_11_18-04-26.sql         ← Q51–Q56
        ├── day_12_19-04-26.sql         ← Q57–Q61
        ├── day_13_21-04-26.sql         ← Q62–Q66
        ├── day_14_22-04-26.sql         ← Q67–Q71
        ├── day_15_23-04-26.sql         ← Q72–Q75
        ├── day_16_24-04-26.sql         ← Q76–Q81
        ├── day_17_26-04-26.sql         ← Q82–Q84
        ├── day_18_28-04-26.sql         ← Q85–Q88
        ├── day_19_30-04-26.sql         ← Q89–Q91
        ├── day_20_02-05-26.sql         ← Q92–Q95
        └── day_21_05-05-26.sql         ← Q96–Q100
```

## Database
- Engine: MySQL
- Database name: `sql_finance`
- Tables: `customers`, `accounts`, `transactions`, `loans`, `loan_payments`, `merchants`, `cards`, `branches`, `employees`
- Theme: Mimics real banking systems (JPMorgan, Goldman, Stripe, PayPal, Visa)

## File Naming Convention
`day_XX_DD-MM-YY.sql` — e.g. `day_06_12-04-26.sql`

## Commit Workflow
1. Aryan shares solved `.sql` file in chat
2. Claude places it in `finance-domain/practice/`
3. Claude updates the problems table in `finance-domain/README.md`
4. Claude commits with message: `Day X - finance domain: N questions (difficulty)`
5. Claude pushes to `origin main`

## Progress Tracker
| Day | File | Questions | Difficulty |
|-----|------|-----------|------------|
| 1 | day_01_07-04-26.sql | Q1–Q6 | Easy / Medium / Hard |
| 2 | day_02_08-04-26.sql | Q7–Q12 | Easy / Medium / Hard |
| 3 | day_03_09-04-26.sql | Q13–Q18 | Easy / Medium / Hard |
| 4 | day_04_10-04-26.sql | Q19–Q23 | Easy / Medium |
| 5 | day_05_11-04-26.sql | Q24–Q25 | Hard |
| 6 | day_06_12-04-26.sql | Q27–Q32 | Easy / Medium |
| 7 | day_07_13-04-26.sql | Q33–Q37 | Easy / Medium |
| 8 | day_08_14-04-26.sql | Q38–Q42 | Medium |
| 9 | day_09_15-04-26.sql | Q43–Q46 | Easy / Medium |
| 10 | day_10_16-04-26.sql | Q47–Q50 | Easy / Medium |
| 11 | day_11_18-04-26.sql | Q51–Q56 | Easy / Medium |
| 12 | day_12_19-04-26.sql | Q57–Q61 | Easy / Medium |
| 13 | day_13_21-04-26.sql | Q62–Q66 | Easy / Medium |
| 14 | day_14_22-04-26.sql | Q67–Q71 | Easy / Medium |
| 15 | day_15_23-04-26.sql | Q72–Q75 | Medium |
| 16 | day_16_24-04-26.sql | Q76–Q81 | Medium |
| 17 | day_17_26-04-26.sql | Q82–Q84 | Medium |
| 18 | day_18_28-04-26.sql | Q85–Q88 | Medium |
| 19 | day_19_30-04-26.sql | Q89–Q91 | Medium |
| 20 | day_20_02-05-26.sql | Q92–Q95 | Easy / Medium |
| 21 | day_21_05-05-26.sql | Q96–Q100 | Medium |

## Topics Covered So Far
- `WHERE`, `IN`, `YEAR()`, `MONTH()`, `MONTHNAME()`
- `GROUP BY`, `HAVING`, `ORDER BY`
- `JOIN` (INNER, using USING())
- Aggregations: `SUM()`, `AVG()`, `COUNT()`, `MAX()`
- Window Functions: `ROW_NUMBER()`, `DENSE_RANK()`, `LAG()`, `SUM() OVER()`
- CTEs (`WITH`), Multi-CTE chains
- Correlated subqueries
- `CASE`, `NULLIF()`, `ROUND()`
- Running totals, month-over-month analysis, fraud detection, loan amortization
- `NOT IN` subquery, accounts with no transactions
