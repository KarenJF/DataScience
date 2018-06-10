/*  First Join */
/* 1. Try pulling all the data from the accounts table, and all the data from the orders table.*/
select
    orders.*,
    accounts.*
from orders
join accounts
on orders.account_id = accounts.id;

/* 2. Try pulling standard_qty, gloss_qty, and poster_qty from the orders table,
and the website and the primary_poc from the accounts table.*/
select
    orders.standard_qty,
    orders.gloss_qty,
    orders.poster_qty
    accounts.website,
    accounts.primary_poc
from orders
join accounts
on orders.account_id = accounts.id;

/* JOIN */
/* 1. Provide a table for all web_events associated with account name of Walmart.
There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event.
Additionally, you might choose to add a fourth column to assure only Walmart events were chosen. */
select
    accounts.primary_poc,
    web_events.occurred_at,
    web_events.channel,
    accounts.name

from web_events
JOIN accounts
on web_events.account_id = accounts.id
where accounts.name = 'Walmart';

/* 2. Provide a table that provides the region for each sales_rep along with their associated accounts.
Your final table should include three columns: the region name, the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name. */
select
    region.name,
    sales_reps.name,
    accounts.name
from region
join sales_reps on region.id = sales_reps.region_id
join accounts on sales_reps.id = accounts.sales_rep_id
order by accounts.name;

/* 3. Provide the name for each region for every order,
as well as the account name and the unit price they paid (total_amt_usd/total) for the order.
Your final table should have 3 columns: region name, account name, and unit price.
A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero. */
select
    region.name,
    accounts.name,
    (orders.total_amt_usd/(orders.total + 0.01)) as unit_price
from region
join sales_reps on region.id = sales_reps.region_id
join accounts on sales_reps.id = accounts.sales_rep_id
join orders on orders.account_id = accounts.id;

/* FINAL JOIN CHECK */
/* 1. Provide a table that provides the region for each sales_rep along with their associated accounts.
This time only for the Midwest region.
Your final table should include three columns: the region name, the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name.*/
select
    r.name,
    s.name,
    a.name
from region r
join sales_reps s on r.id= s.region_id
join accounts a on s.id = a.sales_rep_id
where r.name = 'Midwest'
order by a.name;

/* 2. Provide a table that provides the region for each sales_rep along with their associated accounts.
This time only for accounts where the sales rep has a first name starting with S and in the Midwest region.
Your final table should include three columns: the region name, the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name. */
select
    r.name,
    s.name,
    a.name
from region r
join sales_reps s on r.id= s.region_id
join accounts a on s.id = a.sales_rep_id
where r.name = 'Midwest' and s.name like '%S'
order by a.name;

/* 3. Provide a table that provides the region for each sales_rep along with their associated accounts.
This time only for accounts where the sales rep has a last name starting with K and in the Midwest region.
Your final table should include three columns: the region name, the sales rep name, and the account name.
Sort the accounts alphabetically (A-Z) according to account name. */
select
    r.name,
    s.name,
    a.name
from region r
join sales_reps s on r.id= s.region_id
join accounts a on s.id = a.sales_rep_id
where r.name = 'Midwest' and s.name like '% K'
order by a.name;
