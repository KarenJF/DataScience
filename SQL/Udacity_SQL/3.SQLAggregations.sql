/* SUM */
/* 1.Find the total amount of poster_qty paper ordered in the orders table.*/
select
    sum(poster_qty)
from orders;

/* 2. Find the total amount of standard_qty paper ordered in the orders table.*/
select
    sum(standard_qty)
from orders;

/* 3. Find the total dollar amount of sales using the total_amt_usd in the orders table. */
select
    sum(total_amt_usd)
from orders;

/* 4. Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table.
This should give a dollar amount for each order in the table. */
select
    id,
    sum(standard_amt_usd + gloss_amt_usd) as total_amt
from orders
group by
    id;

/* 5. Find the standard_amt_usd per unit of standard_qty paper.
Your solution should use both an aggregation and a mathematical operator. */
select
    sum(standard_amt_usd)/sum(standard_qty) as per_unit
from orders;

/* MIN, MAX, & AVERAGE */
/* 1. When was the earliest order ever placed? You only need to return the date.*/
select
    min(occurred_at)
from orders;

/* 2. Try performing the same query as in question 1 without using an aggregation function. */
select
    occurred_at
from orders
order by occurred_at
limit 1;

/* 3.When did the most recent (latest) web_event occur? */
select
    max(occurred_at)
from web_events;

/* 4. Try to perform the result of the previous query without using an aggregation function.*/
select
    occurred_at
from web_events
order by occurred_at desc
limit 1;


/* 5. Find the mean (AVERAGE) amount spent per order on each paper type,
as well as the mean amount of each paper type purchased per order.
Your final answer should have 6 values -
one for each paper type for the average number of sales, as well as the average amount. */
SELECT AVG(standard_qty) mean_standard, AVG(gloss_qty) mean_gloss,
           AVG(poster_qty) mean_poster, AVG(standard_amt_usd) mean_standard_usd,
           AVG(gloss_amt_usd) mean_gloss_usd, AVG(poster_amt_usd) mean_poster_usd
FROM orders;

/* GROUP BY */
/* 1. Which account (by name) placed the earliest order?
Your solution should have the account name and the date of the order.*/
select
    a.name,
    o.occurred_at
from accounts a
join orders o
on a.id = o.account_id
order by o.occurred_at
limit 1;

/* 2.Find the total sales in usd for each account.
You should include two columns -
the total sales for each company's orders in usd and the company name. */
select
    a.name,
    sum(total_amt_usd)
from accounts a
join orders o
on a.id = o.account_id
group by
    a.name;

/* 3. Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event?
Your query should return only three values - the date, channel, and account name. */
select
    w.occurred_at,
    w.channel,
    a.name
from web_events w
join accounts a
on w.account_id = a.id
order by w.occurred_at desc
limit 1;

/* 4. Find the total number of times each type of channel from the web_events was used.
Your final table should have two columns - the channel and the number of times the channel was used. */
select
    channel,
    count(occurred_at)
from web_events
group by channel;

/* 5. Who was the primary contact associated with the earliest web_event? */
select
    a.primary_poc
from accounts a
join web_events w
on a.id = w.account_id
order by w.occurred_at
limit 1;

/* 6. What was the smallest order placed by each account in terms of total usd.
Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest. */
select
    a.name as account_name,
    min(o.total_amt_usd)
from accounts a
join orders o on a.id = o.account_id
group by
    a.name
order by
    min(o.total_amt_usd) ;

/* 7. Find the number of sales reps in each region.
Your final table should have two columns - the region and the number of sales_reps.
Order from fewest reps to most reps. */
select
    r.name as region_name,
    count(s.name) as num_sales
from region r
join sales_reps s on r.id = s.region_id
group by region_name
order by num_sales;

/* GROUP BY II */
/* 1. For each account, determine the average amount of each type of paper they purchased across their orders.
Your result should have four columns -
one for the account name and one for the average quantity purchased for each of the paper types for each account. */
select
    a.name as account_name,
    AVG(standard_qty) as avg_standard,
    avg(gloss_qty) as avg_gloss,
    avg(poster_qty) as avg_poster

from accounts a
join orders o on a.id = o.account_id
group by account_name;

/* 2. For each account, determine the average amount spent per order on each paper type.
Your result should have four columns -
one for the account name and one for the average amount spent on each paper type. */
select
    a.name as account_name,
    AVG(o.standard_amt_usd) as avg_standard,
    avg(o.gloss_amt_usd) as avg_gloss,
    avg(o.poster_amt_usd) as avg_poster
from accounts a
join orders o on a.id = o.account_id
group by account_name;

/* 3. Determine the number of times a particular channel was used in the web_events table for each sales rep.
Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences.
Order your table with the highest number of occurrences first. */
SELECT
    s.name as sales_name,
    w.channel,
    count(w.occurred_at) as num_occurrence
from sales_reps s
join accounts a on s.id = a.sales_rep_id
join web_events w on a.id = w.account_id
group by
    sales_name,
    channel
order by num_occurrence desc;

/* 4. Determine the number of times a particular channel was used in the web_events table for each region.
Your final table should have three columns - the region name, the channel, and the number of occurrences.
Order your table with the highest number of occurrences first. */
select
    r.name as region_name,
    w.channel,
    count(w.occurred_at) as num_occurrence
from region r
join sales_reps s on r.id = s.region_id
join accounts a on s.id = a.sales_rep_id
join web_events w on a.id = w.account_id
group by
    region_name,
    channel
order by
    num_occurrence desc;

/* DISTINCT */
/* 1.Use DISTINCT to test if there are any accounts associated with more than one region. */
with t1 as(
    select DISTINCT
        a.name as account_name,
        r.name as region_name
        from accounts a
        join sales_reps s on a.sales_rep_id = s.id
        join region r on r.id = s.region_id
        order by account_name)

select
    t1.account_name,
    count(t1.*)
from t1
group by
    t1.account_name
order by count(t1.*) desc;

/* 2. Have any sales reps worked on more than one account? */
with t1 as
    (select
    s.name as sales_name,
    a.name as account_name,
    count(a.name) as num_account
from sales_reps s
join accounts a on s.id = a.sales_rep_id
group by
    sales_name,
    account_name)

select
    t1.sales_name,
    count(t1.account_name)
from t1
group by t1.sales_name
order by count(t1.account_name);

/* HAVING */
/* 1. How many of the sales reps have more than 5 accounts that they manage? */
SELECT
    s.name as sales_name,
    count(a.name)
from sales_reps s
join accounts a on s.id = a.sales_rep_id
group by sales_name
having count(a.name) >5
order by count(a.name);

/* 2.How many accounts have more than 20 orders? */
select
    a.name as account_name,
    count(o.*) as num_orders
from accounts a
join orders o on a.id = o.account_id
group by account_name
HAVING count(o.*) > 20
order by num_orders;

/* 3. Which account has the most orders? */
SELECT
    a.name as account_name,
    count(o.*)
from accounts a
join orders o on a.id = o.account_id
group by
    account_name
order by count(o.*) desc
limit 1;

/* 4.How many accounts spent more than 30,000 usd total across all orders? */
select
    a.name,
    sum(o.total_amt_usd)
from accounts a
join orders o on a.id = o.account_id
group by
    a.name
having sum(o.total_amt_usd) > 30000
order by sum(o.total_amt_usd);

/* 5.How many accounts spent less than 1,000 usd total across all orders? */
SELECT
    a.name,
    sum(o.total_amt_usd)
from accounts a
join orders o
on a.id = o.account_id
group by
    a.name
having sum(o.total_amt_usd) <1000
order by sum(o.total_amt_usd);

/* 6. Which account has spent the most with us? */
SELECT
    a.name as account_name,
    sum(o.total_amt_usd)
from accounts a
join orders o
on a.id = o.account_id
group by
    a.name
order by sum(o.total_amt_usd) desc
limit 1;

/* 7. Which account has spent the least with us? */
SELECT
    a.name as account_name,
    sum(o.total_amt_usd)
from accounts a
join orders o
on a.id = o.account_id
group by
    a.name
order by sum(o.total_amt_usd)
limit 1;

/* 8. Which accounts used facebook as a channel to contact customers more than 6 times?*/
select
    a.name as account_name,
    w.channel,
    count(w.occurred_at) as num_contact
from accounts a
join web_events w
on a.id = w.account_id
where w.channel = 'facebook'
group by a.name, w.channel
HAVING count(w.occurred_at) > 6
order by num_contact desc;

/* 9.Which account used facebook most as a channel? */
select
    a.name,
    w.channel,
    count(w.occurred_at) as num_contact
from accounts a
join web_events w
on a.id = w.account_id
where w.channel = 'facebook'
group by
    a.name,
    w.channel
order by num_contact desc
limit 1;

/* Which channel was most frequently used by most accounts? */
select
    w.channel,
    a.name,
    count(*)
from web_events w
join accounts a
on w.account_id = a.id
GROUP by
    w.channel,
    a.name
order by count(*) desc;

/* WORKING WITH DATES */
/* 1. Find the sales in terms of total dollars for all orders in each year,
ordered from greatest to least.
Do you notice any trends in the yearly sales totals? */
select
    DATE_PART('year',o.occurred_at) as year,
    sum(total_amt_usd)
from orders o
GROUP by 1
order by sum(total_amt_usd) desc ;

/* 2. Which month did Parch & Posey have the greatest sales in terms of total dollars?
Are all months evenly represented by the dataset? */
select
    DATE_PART('month', occurred_at) as month,
    sum(total_amt_usd)
from orders
where occurred_at between '2014-01-01' and '2017-01-01'
group by 1
order by 2 desc;

/* 3. Which year did Parch & Posey have the greatest sales in terms of total number of orders?
Are all years evenly represented by the dataset? */
/* 2013 and 2017 are not evenly represented */
select
    DATE_PART('year', occurred_at) as year,
    count(*)
from orders
group by 1
order by 2 desc;

/* 4. Which month did Parch & Posey have the greatest sales in terms of total number of orders?
Are all months evenly represented by the dataset? */
/* 2013 and 2017 are not evenly represented */
select
    DATE_PART('month', occurred_at) as month,
    count(*)
from orders
where occurred_at between '2014-01-01' and '2017-01-01'
group by 1
order by 2 desc;

/* 5. In which month of which year did Walmart spend the most on gloss paper in terms of dollars? */
select
    DATE_TRUNC('month', o.occurred_at) as month,
    SUM(o.gloss_amt_usd)
from orders o
join accounts a
on o.account_id = a.id
where a.name ='Walmart'
GROUP by month
order by SUM(o.gloss_amt_usd) desc
limit 1;

/* CASE */
/* We would like to understand 3 different levels of customers based on the amount associated with their purchases.
The top branch includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd.
The second branch is between 200,000 and 100,000 usd.
The lowest branch is anyone under 100,000 usd.
Provide a table that includes the level associated with each account.
You should provide the account name, the total sales of all orders for the customer, and the level.
Order with the top spending customers listed first. */
select
    a.name,
    sum(o.total_amt_usd) as total_sales,
    (CASE WHEN sum(o.total_amt_usd)> 200000 then 'FIRST'
         WHEN sum(o.total_amt_usd)> 100000 then 'SECOND'
         ELSE 'THIRD' end) As level
from accounts a
join orders o
on a.id = o.account_id
group by a.name
order by 2 desc;

/* 2. We would now like to perform a similar calculation to the first,
but we want to obtain the total amount spent by customers only in 2016 and 2017.
Keep the same levels as in the previous question.
Order with the top spending customers listed first.*/
select
    a.name,
    sum(o.total_amt_usd) as total_sales,
    (CASE WHEN sum(o.total_amt_usd)> 200000 then 'FIRST'
         WHEN sum(o.total_amt_usd)> 100000 then 'SECOND'
         ELSE 'THIRD' end) As level
from accounts a
join orders o
on a.id = o.account_id
where o.occurred_at >= '2016-01-01'
group by a.name
order by 2 desc;

/* 3. We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders.
Create a table with the sales rep name, the total number of orders,
and a column with top or not depending on if they have more than 200 orders.
Place the top sales people first in your final table. */
select
    s.name as sales_name,
    count(o.occurred_at) as num_orders,
    (CASE WHEN count(o.occurred_at) >200  then 'YES'
          else 'NO' end) as TOP
FROM
    sales_reps s
join accounts a
on s.id = a.sales_rep_id
join orders o
on a.id = o.account_id
group by
    s.name
order by 2 desc;

/* 4. The previous didn't account for the middle, nor the dollar amount associated with the sales.
Management decides they want to see these characteristics represented as well.
We would like to identify top performing sales reps,
which are sales reps associated with more than 200 orders or more than 750000 in total sales.
The middle group has any rep with more than 150 orders or 500000 in sales.
Create a table with the sales rep name, the total number of orders,
total sales across all orders, and a column with top, middle, or low depending on this criteria.
Place the top sales people based on dollar amount of sales first in your final table.
You might see a few upset sales people by this criteria! */
select
    s.name as sales_name,
    count(o.occurred_at) as num_orders,
    sum(o.total_amt_usd) as total_sales,
    (case when (count(o.occurred_at) > 200 or sum(o.total_amt_usd) > 750000) then 'top'
          when (count(o.occurred_at) > 150 or sum(o.total_amt_usd) > 500000) then 'middle'
          else 'low' end) as level
from sales_reps s
join accounts a
on s.id = a.sales_rep_id
join orders o
on a.id = o.account_id
group by
    s.name
order by 3 desc;
