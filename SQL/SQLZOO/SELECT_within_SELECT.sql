/* 1. List each country name where the population is larger than that of 'Russia'.*/
SELECT
    name
FROM world
WHERE population > (SELECT population FROM world where name = 'Russia');

/* 2. Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.*/
SELECT
    name
FROM world
WHERE continent = 'Europe' and
    gdp/population > (SELECT gdp/population FROM world where name = 'United Kingdom');

/* 3. List the name and continent of countries in the continents containing either Argentina or Australia.
Order by name of the country. */
SELECT
    name,
    continent
FROM world
where continent in (SELECT continent from world where name in ('Argentina','Australia'))
order by name;

/* 4. Which country has a population that is more than Canada but less than Poland?
Show the name and the population.*/
SELECT
    name,
    population
FROM world
where population > (SELECT population from world where name = 'Canada') and
    population < (SELECT population from world where name = 'Poland');

/* 5. Germany (population 80 million) has the largest population of the countries in Europe.
Austria (population 8.5 million) has 11% of the population of Germany.
Show the name and the population of each country in Europe.
Show the population as a percentage of the population of Germany.*/
SELECT
    name,
    CONCAT(ROUND(population/(SELECT population from world where name = 'Germany')*100),'%')
FROM world
WHERE continent = 'Europe';

/* 6. Which countries have a GDP greater than every country in Europe?
[Give the name only.] (Some countries may have NULL gdp values)*/
SELECT
    name
FROM world
WHERE gdp > ALL(SELECT gdp from world where continent = 'Europe' and gdp >0);

/* 7. Find the largest country (by area) in each continent, show the continent, the name and the area*/
/* method 1 */
WITH t1 as (SELECT
    continent,
    max(area) as max_area
FROM world
group by continent)

SELECT
    world.continent,
    world.name,
    world.area
FROM world
join t1 on world.continent = t1.continent
where world.area = t1.max_area;

/* method 2 */
SELECT continent, name, area FROM world x
  WHERE area >= ALL
    (SELECT area FROM world y
        WHERE y.continent=x.continent
          AND area>0)

/* 8. List each continent and the name of the country that comes first alphabetically.*/
SELECT
    a.continent,
    a.name
FROM world a
WHERE a.name <= ALL
    (SELECT name from world b
        where a.continent = b.continent);

/* 9. Find the continents where all countries have a population <= 25000000.
Then find the names of the countries associated with these continents.
Show name, continent and population. */
WITH t1 as
    (SELECT
        continent,
        max(population) as max_pop
     FROM world
     group by continent
     having max(population) <= 25000000)

SELECT
    a.name,
    a.continent,
    a.population

FROM world a
join t1 on a.continent = t1.continent;

/* method 2 */
SELECT name, continent, population
FROM world x
WHERE 25000000  > ALL(SELECT population FROM world y WHERE x.continent = y.continent AND y.population > 0)

/* 10. Some countries have populations more than three times that of any of their neighbours
(in the same continent). Give the countries and continents. */
SELECT
    name, continent
FROM world x
WHERE population > ALL(SELECT population*3 from world y WHERE x.continent = y.continent
    and y.population > 0 and x.name != y.name);
