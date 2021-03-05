--- Lesson 7 
--- SQL Advanced Join & Performance Tuning

--- FULL OUTER JOIN
--- each account who has a sales rep and each sales rep that has an account (all of the columns in these returned rows will be full)
--- but also each account that does not have a sales rep and each sales rep that does not have an account (some of the columns in these returned rows will be empty)
SELECT s.name rep, a.name account
FROM accounts a
FULL JOIN sales_reps s
    ON s.id = a.sales_rep_id;

--- Inequality JOINS
SELECT 
	a.name account, 
	a.primary_poc, 
    s.name rep
FROM accounts a
LEFT JOIN sales_reps s
	ON s.id = a.sales_rep_id
    AND a.primary_poc < s.name;

--- SELF JOIN
SELECT 
	w1.id AS w1_id,
	w1.account_id AS w1_account_id,
    w1.occurred_at AS w1_occurred_at,
    w1.channel AS w1_channel,
    w2.id AS w2_id,
    w2.account_id AS w2_account_id,
    w2.occurred_at AS w2_occurred_at,
    w2.channel AS w2_channel
FROM web_events w1
JOIN web_events w2
	ON w1.account_id = w2.account_id
    AND w1.occurred_at > w2.occurred_at
    AND w1.occurred_at <= w2.occurred_at + INTERVAL '1 day'
ORDER BY w1.account_id, w2.occurred_at

--- UNION
--- Write a query that uses UNION ALL on two instances (and selecting all columns) of the accounts table. Then inspect the results and answer the subsequent quiz.
SELECT *
FROM accounts

UNION  

SELECT *
FROM accounts

--- Add a WHERE clause to each of the tables that you unioned in the query above, filtering the first table where name equals Walmart and filtering the second table where name equals Disney. Inspect the results then answer the subsequent quiz.
SELECT *
FROM accounts
WHERE name = 'Walmart'

UNION  

SELECT *
FROM accounts
WHERE name = 'Disney'

--- Performing Operations on a Combined Dataset
WITH double_accounts AS (SELECT *
FROM accounts

UNION ALL

SELECT *
FROM accounts)

SELECT name, COUNT(*) name_count
FROM double_accounts
GROUP BY name;