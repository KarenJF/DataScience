/* SELF JOIN */
/* 1. How many stops are in the database. */
select
    count(id)
from stops;

/* 2. Find the id value for the stop 'Craiglockhart' */
select id
from stops
where name = 'Craiglockhart';

/* 3. Give the id and the name for the stops on the '4' 'LRT' service.*/
select id, name
from stops
join route on stops.id = route.stop
where route.num = '4';

/* 4. The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53).
Run the query and notice the two services that link these stops have a count of 2.
Add a HAVING clause to restrict the output to these two routes. */
select company, num, count(*)
from route
join stops on route.stop = stops.id
where stops.id in (53,149)
group by company, num
having count(*) =2;

/* 5. Execute the self join shown and observe that
b.stop gives all the places you can get to from Craiglockhart, without changing routes.
Change the query so that it shows the services from Craiglockhart to London Road.*/
SELECT
    a.company,
    a.num,
    a.stop,
    sa.name,
    b.stop,
    sb.name

from route a
join route b
on a.num = b.num and a.company = b.company
join stops sa on a.stop = sa.id
join stops sb on b.stop = sb.id
where sa.name = 'Craiglockhart' and
sb.name = 'London Road';

/* 7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith') */
SELECT DISTINCT
    a.company,
    a.num
from route a
join route b on a.company = b.company and a.num = b.num
where a.stop = 115 and b.stop = 137;

/* 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross' */
SELECT DISTINCT
    a.company,
    a.num
from route a
join route b on a.company = b.company and a.num = b.num
join stops sa on a.stop = sa.id
join stops sb on b.stop = sb.id
where sa.name = 'Craiglockhart' and sb.name = 'Tollcross';

/* 9. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus,
including 'Craiglockhart' itself, offered by the LRT company.
Include the company and bus no. of the relevant services. */
SELECT DISTINCT
    sb.name,
    a.company,
    a.num
from route a
join route b on a.company = b.company and a.num = b.num
join stops sa on a.stop = sa.id
join stops sb on b.stop = sb.id
where sa.name = 'Craiglockhart' and a.company = 'LRT';

/* 10. Find the routes involving two buses that can go from Craiglockhart to Sighthill.
Show the bus no. and company for the first bus, the name of the stop for the transfer,
and the bus no. and company for the second bus. */
WITH t1 as (
    SELECT a.company, a.num, b.stop
    FROM route a JOIN route b ON (a.company=b.company AND a.num=b.num)
    WHERE a.stop = (SELECT ID FROM stops where name = 'Craiglockhart')

),

    t2 as (
    SELECT a.company, a.num, b.stop
    FROM route a JOIN route b ON (a.company=b.company AND a.num=b.num)
    WHERE a.stop = (SELECT ID from stops where name = 'Sighthill')
    )

SELECT DISTINCT
    t1.num,
    t1.company,
    t3.name,
    t2.num,
    t2.company
from t1
join t2 on t1.stop = t2.stop
join stops t3 on t3.id = t1.stop;
