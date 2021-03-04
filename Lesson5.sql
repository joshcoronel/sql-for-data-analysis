--- SQL Data Cleaning

--- Left & Right
--- In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using. A list of extensions (and pricing) is provided here. Pull these extensions and provide how many of each website type exist in the accounts table.
SELECT RIGHT(website, 3), COUNT(*)
FROM accounts
GROUP BY RIGHT(website, 3);

--- There is much debate about how much the name (or even the first letter of a company name) matters. Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number).
SELECT LEFT(name, 1), COUNT(*)
FROM accounts
GROUP BY LEFT(name, 1)
ORDER BY 2 DESC;

---Use the accounts table and a CASE statement to create two groups: one group of company names that start with a number and a second group of those company names that start with a letter. What proportion of company names start with a letter?
SELECT 
	CASE WHEN LEFT(UPPER(name),1) IN ('0','1','2','3','4','5','6','7','8','9')
                         THEN 'Number' ELSE 'Letter'
                         END AS first_char,
    COUNT(*)
FROM accounts
GROUP BY 1

--- Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?
SELECT 
	CASE WHEN LEFT(UPPER(name),1) IN ('A','E','I','O','U')
                         THEN 'vowel' ELSE 'not vowel'
                         END AS first_char,
                                COUNT(*)
FROM accounts
GROUP BY 1

--- POSITION & STRPOS
--- Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.
SELECT 
    LEFT(primary_poc, POSITION(' ' in primary_poc) - 1) first_name, 
    RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' in primary_poc)) last_name
FROM accounts;

--- Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.
SELECT 
    LEFT(name, POSITION(' ' in name) - 1) first_name, 
    RIGHT(name, LENGTH(name) - POSITION(' ' in name)) last_name
FROM sales_reps

--- CONCAT
--- Each company in the accounts table wants to create an email address for each primary_poc. The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.
WITH t1 AS (
 SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts)

SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com')
FROM t1;

--- You may have noticed that in the previous solution some of the company names include spaces, which will certainly not work in an email address. See if you can create an email address that will work by removing all of the spaces in the account name, but otherwise your solution should be just as in question 1. Some helpful documentation is here.
WITH t1 AS (
 SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', REPLACE(name, ' ', ''), '.com')
FROM  t1;


--- CAST
SELECT CONCAT(SUBSTR(date,7,4), '-', SUBSTR(date,1,2), '-', SUBSTR(date, 4, 2))::DATE,
	date
FROM sf_crime_data
LIMIT 10;

--- COALESCE
SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;