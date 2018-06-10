/* Subqueries */
/* 1. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.*/
/* sale name, region, total amount for that sale rep  */
WITH t1 as (
    SELECT
        s.name as sales_name,
        r.name as region_name,
        sum(total_amt_usd) as total_amount
    from sales_reps s
    join region r on s.region_id = r.id
    join accounts a on s.id = a.sales_rep_id
    join orders o on a.id = o.account_id
    group by
        s.name,
        r.name
    order by 3 desc),

    t2 as (
    SELECT
        t1.region_name as region_name,
        max(t1.total_amount) as total_amount
    from t1
    group by
        t1.region_name
    )

select
    t1.sales_name,
    t2.region_name,
    t2.total_amount
from t1
join t2
on t1.region_name = t2.region_name and
   t1.total_amount = t2.total_amount;

/* 2.For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed? */
WITH t1 as (
select
    r.name as region_name,
    sum(total_amt_usd) as total_amount
from region r
join sales_reps s on r.id = s.region_id
join accounts a on s.id = a.sales_rep_id
join orders o on a.id = o.account_id
group by r.name
order by 2 desc
limit 1),

t2 as (
select
    r.name as region_name,
    count(o.total) as total_order
from region r
    join sales_reps s on r.id = s.region_id
    join accounts a on s.id = a.sales_rep_id
    join orders o on a.id = o.account_id
group by r.name)

select
    t1.region_name,
    t1.total_amount,
    t2.total_order
from t1
join t2 on t1.region_name = t2.region_name;

/* 3.For the name of the account that purchased the most (in total over their lifetime as a customer) standard_qty paper,
how many accounts still had more in total purchases?  */
WITH t1 as(
select
    a.name as account_name,
    sum(o.standard_qty) as total_stand_qty,
    sum(o.total) total
from accounts a
join orders o on a.id = o.account_id
group by
    a.name
order by 2 desc
limit 1),

t2 as (
select
    a.name as account_name
from accounts a
join orders o on a.id = o.account_id
group by a.name
having sum(o.total) > (select total from t1))

select
    count(*)
from t2;

/* 4. For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd,
how many web_events did they have for each channel? */
WITH t1 as (
select
    a.id,
    a.name as account_name,
    sum(total_amt_usd) as total_amount
from accounts a
join orders o on a.id = o.account_id
group by a.id, a.name
order by 3 desc
limit 1),

t2 as (
select
    w.account_id,
    w.channel,
    count(w.occurred_at) as num_events
from web_events w
group by 1,2)

select
    t1.account_name,
    t2.channel,
    t2.num_events
from t1
join t2 on t1.id = t2.account_id
order by 3 desc;

/* 5. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts? */
WITH t1 as (
SELECT
    a.id, a.name, sum(total_amt_usd) as total
from accounts a
join orders o on a.id = o.account_id
group by 1, 2
order by 3 desc
limit 10)

select avg(total)
from t1;

/* 6. What is the lifetime average amount spent in terms of total_amt_usd
for only the companies that spent more than the average of all accounts.*/
WITH t1 as (
select
    avg(total_amt_usd) as avg_total
from orders),

t2 as (
    select
    a.id, a.name, avg(total_amt_usd) as total
from accounts a
join orders o on a.id = o.account_id
group by 1, 2)

select
    avg(t2.total)
from t2
where t2.total > (select avg_total from t1);
