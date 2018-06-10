/* LIMIT */
select
    occurred_at,
    account_id,
    channel
from web_events
limit 15;

/* ORDER BY */
/* 1. Write a query to return the 10 earliest orders in the orders table.
Include the id, occurred_at, and total_amt_usd. */
select
    id,
    occurred_at,
    total_amt_usd
from orders
order by occurred_at
limit 10;

/* 2. Write a query to return the top 5 orders in terms of largest total_amt_usd.
Include the id, account_id, and total_amt_usd. */
select
    id,
    account_id,
    total_amt_usd
from orders
order by total_amt_usd desc
limit 5;

/* 3. Write a query to return the bottom 20 orders in terms of least total.
Include the id, account_id, and total. */
select
    id,
    account_id,
    total
from orders
order by total
limit 20;

/* ORDRE BY II */
/* 1. Write a query that returns the top 5 rows from orders ordered according to newest to oldest,
but with the largest total_amt_usd for each date listed first for each date. */
select * from orders
order by occurred_at desc, total_amt_usd desc
limit 5;

/* 2. Write a query that returns the top 10 rows from orders ordered according to oldest to newest,
but with the smallest total_amt_usd for each date listed first for each date. */
select * from orders
order by occurred_at, total_amt_usd
limit 10;

/* WHERE */
/* 1. Pull the first 5 rows and all columns from the orders table that
have a dollar amount of gloss_amt_usd greater than or equal to 1000.*/
select * from orders
where gloss_amt_usd >= 1000
limit 5;

/* 2. Pull the first 10 rows and all columns from the orders table that have a total_amt_usd less than 500.*/
select * from orders
where total_amt_usd < 500
limit 10;

/* WHERE with Non-Numeric */
/* Filter the accounts table to include the company name, website, and the primary point of contact (primary_poc)
for Exxon Mobil in the accounts table.*/
select
    name,
    website,
    primary_poc
from accounts
WHERE name = 'Exxon Mobil';

/* Arithmetic Operations */
/* 1. Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order.
Limit the results to the first 10 orders, and include the id and account_id fields. */
select id,
       account_id,
       standard_amt_usd/standard_qty as unit_price
from orders
limit 10;

/* 2. Write a query that finds the percentage of revenue that comes from poster paper for each order.
You will need to use only the columns that end with _usd. (Try to do this without using the total column).
Include the id and account_id fields. */
select
    id,
    account_id,
    poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd) AS post_percentage
from orders;

/* LIKE */
/* 1. All the companies whose names start with 'C'. */
select name from accounts
where name like 'C%';

/* 2. All companies whose names contain the string 'one' somewhere in the name. */
select name from accounts
where name like '%one%';

/* 3.All companies whose names end with 's'. */
select name from accounts
where name like '%s';

/* IN */
/* 1. Use the accounts table to find the account name, primary_poc, and sales_rep_id
for Walmart, Target, and Nordstrom. */
select
    name,
    primary_poc,
    sales_rep_id
from accounts
WHERE name in ('Walmart','Target','Nordstrom');

/* 2. Use the web_events table to find all information regarding individuals
who were contacted via the channel of organic or adwords. */
select * from web_events
where channel in ('organic','adwords');

/* NOT */
/* 1. Use the accounts table to find the account name, primary poc, and sales rep id
for all stores except Walmart, Target, and Nordstrom. */
select
    name,
    primary_poc,
    sales_rep_id
from accounts
WHERE name not in ('Walmart','Target','Nordstrom');

/* 2. Use the web_events table to find all information regarding individuals who were contacted via
any method except using organic or adwords methods. */
select * from web_events
where channel not in ('organic','adwords');

/* 3. All the companies whose names do not start with 'C'. */
select  name
from accounts
where name not like 'C%';

/* 4. All companies whose names do not contain the string 'one' somewhere in the name. */
select name
from accounts
WHERE name not like '%one%';

/* 5. All companies whose names do not end with 's'. */
select name
from accounts
WHERE name not like '%s';

/* AND and BETWEEN */
/* 1. Write a query that returns all the orders where the standard_qty is over 1000,
the poster_qty is 0, and the gloss_qty is 0. */
select *
from orders
where standard_qty >1000 and
      poster_qty = 0 and
      gloss_qty = 0;

/* 2. Using the accounts table find all the companies whose names do not start with 'C' and end with 's'. */
select *
from accounts
where name not like 'C%' and name like '%s';

/* 3. Use the web_events table to find all information regarding individuals who were contacted via organic or adwords
and started their account at any point in 2016 sorted from newest to oldest. */
select *
from web_events
where channel in ('organic','adwords') and
occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
order by occurred_at desc;

/* OR */
/* Find list of orders ids where either gloss_qty or poster_qty is greater than 4000.
Only include the id field in the resulting table. */
select id
from orders
where gloss_qty > 4000 or poster_qty >4000;

/* Write a query that returns a list of orders where the standard_qty is zero and
either the gloss_qty or poster_qty is over 1000. */
select *
from orders
WHERE standard_qty = 0 and (gloss_qty > 1000 or poster_qty >1000);

/* Find all the company names that start with a 'C' or 'W',
and the primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'. */
select *
from accounts
WHERE (name like 'C%' or name like 'W%') and
      (primary_poc like '%ana%' or primary_poc like '%Ana%' ) and
      primary_poc not like '%eana%';
