/* LEFT and RIGHT */

/* 1. In the accounts table, there is a column holding the website for each company.
The last three digits specify what type of web address they are using.
A list of extensions (and pricing) is provided here.
Pull these extensions and provide how many of each website type exist in the accounts table.*/
SELECT
    right(website,3) as extensions,
    count(*)
FROM accounts
group by extensions;

/* 2. There is much debate about how much the name (or even the first letter of a company name) matters.
Use the accounts table to pull the first letter of each company name
to see the distribution of company names that begin with each letter (or number). */
SELECT
    LEFT(UPPER(name),1) as first_letter,
    count(*) as num_company
FROM accounts
group by first_letter
order by num_company desc;

/* 3. Use the accounts table and a CASE statement to create two groups:
one group of company names that start with a number and a second group of those company names that start with a letter.
What proportion of company names start with a letter? */
SELECT
    sum(letter),count(name)
FROM (
SELECT
    name,
    (case when left(UPPER(name),1) in ('0','1','2','3','4','5','6','7','8','9')
          then 1 else 0 end) as num,
    (case when left(UPPER(name),1) in ('0','1','2','3','4','5','6','7','8','9')
          then 0 else 1 end) as letter
from accounts)

/* 4. Consider vowels as a, e, i, o, and u.
What proportion of company names start with a vowel, and what percent start with anything else? */
SELECT
    count(*) as total_comp,
    round(sum(vow_num)*100.0/count(*),2) as vow_per,
    round(sum(other_num)*100.0/count(*),2) as other_per,
    sum(vow_num) as vow_comp,
    sum(other_num) as other_comp
from (
SELECT
    name,
    (case when left(UPPER(name),1) in ('A','E','I','O','U') then 1 else 0 end) as vow_num,
    (case when left(UPPER(name),1) in ('A','E','I','O','U') then 0 else 1 end) as other_num
FROM accounts) T1

/* POSITION & STRPOS */
/* 1. Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc. */
SELECT
    left(primary_poc,STRPOS(primary_poc,' ')-1) AS first_name,
    right(primary_poc, length(primary_poc) - STRPOS(primary_poc,' ')) as last_name
FROM accounts;

/* 2. Now see if you can do the same thing for every rep name in the sales_reps table.
Again provide first and last name columns. */
SELECT
	left(name,strpos(name,' ')-1) as first_name,
    right(name,length(name)-strpos(name,' ')) as last_name
from sales_reps

/* CONCAT*/
/* Each company in the accounts table wants to create an email address for each primary_poc.
The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.*/
SELECT
    first_name,
    last_name,
    CONCAT(first_name,'.',last_name,'@',name,'.com')

FROM (
SELECT
    name,
    left(primary_poc,STRPOS(primary_poc,' ')-1) AS first_name,
    right(primary_poc, length(primary_poc) - STRPOS(primary_poc,' ')) as last_name
FROM accounts
) T1

/* CAST */
SELECT * from sf_crime_data limit 10;

SELECT
	date as original_date,
    substr(date,7,4)||'-'||substr(date,1,2)||'-'||substr(date,4,2) as new_date
FROM sf_crime_data

SELECT
	date as original_date,
    (substr(date,7,4)||'-'||substr(date,1,2)||'-'||substr(date,4,2)):: DATE as new_date
FROM sf_crime_data

/* COALESCE */
SELECT *
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

SELECT
    coalesce(a.id,a.id) as fill_id,
    *
FROM accounts a
Left join orders o
on a.id = o.account_id
WHERE o.total is null;

SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, o.standard_qty, o.gloss_qty, o.poster_qty, o.total, o.standard_amt_usd, o.gloss_amt_usd, o.poster_amt_usd, o.total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

SELECT COUNT(*)
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;

SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;
