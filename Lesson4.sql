--- Subqueries & Temporary Tables

--- First Subqueries
SELECT channel,
	AVG(event_count)
FROM
(SELECT DATE_TRUNC('day', occurred_at),
  channel,
  COUNT(*) event_count
  FROM web_events
  GROUP BY 1, 2) sub
GROUP BY channel
ORDER BY 2 DESC

--- More on Subqueries
SELECT AVG(standard_qty) standard_avg,
  AVG(gloss_qty) gloss_avg,
  AVG(poster_qty) poster_avg,
  SUM(total_amt_usd)
FROM orders
WHERE DATE_TRUNC('month',occurred_at) =
  (SELECT MIN(DATE_TRUNC('month',occurred_at)) FROM orders);

--- Subqueries Mania
--- Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
SELECT t3.rep, t2.region, t2.max_sales
FROM(
  SELECT region, MAX(total_sales) max_sales
  FROM (
    SELECT s.name rep, r.name region, SUM(o.total_amt_usd) total_sales
    FROM orders o
    JOIN accounts a
    	ON o.account_id = a.id
    JOIN sales_reps s
    	ON a.sales_rep_id = s.id
    JOIN region r
      ON s.region_id = r.id
    GROUP BY 1, 2
    ORDER BY 3 DESC
  ) t1
  GROUP BY region
) t2
JOIN (
  SELECT s.name rep, r.name region, SUM(o.total_amt_usd) total_sales
  FROM orders o
  JOIN accounts a
    ON o.account_id = a.id
  JOIN sales_reps s
    ON a.sales_rep_id = s.id
  JOIN region r
    ON s.region_id = r.id
  GROUP BY 1, 2
  ORDER BY 3 DESC
) t3
  ON t2.region = t3.region AND t2.max_sales = t3.total_sales
