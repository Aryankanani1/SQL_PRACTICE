# SQL Practice

Daily SQL problem-solving across real-world business domains.
Built to sharpen SQL skills for data and backend engineering interviews.

## Domains

| Domain | Description | Database |
|--------|-------------|----------|
| [Finance](./finance-domain/) | Banking, transactions, loans, cards | MySQL |

> More domains coming soon (e-commerce, healthcare, etc.)

## What's Inside Each Domain

Each domain contains:
- **`*_db_setup.sql`** — schema + seed data to run locally
- **Practice `.sql` files** — one file per problem, each with the problem statement and solution

## How to Use

```bash
# 1. Run the setup file in MySQL
mysql -u root -p < finance-domain/finance_db_setup.sql

# 2. Open any practice file to see the problem + solution
```

## Topics Practiced

- `JOIN` (INNER, LEFT, SELF)
- Aggregations & `GROUP BY` / `HAVING`
- Window Functions (`RANK`, `ROW_NUMBER`, `LAG`, `LEAD`)
- Subqueries & CTEs (`WITH`)
- Date/Time operations
- Conditional logic (`CASE`)
- Indexes & query optimization
