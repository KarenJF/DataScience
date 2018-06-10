/* 1. List the films where the yr is 1962 [Show id, title]*/
SELECT
    id,
    title
FROM movie
where yr= 1962;

/* 2. When was Citizen Kane released?*/
SELECT yr
from movie
where title = 'Citizen Kane';

/* 3. List all of the Star Trek movies,
include the id, title and yr (all of these movies include the words Star Trek in the title).
Order results by year. */
SELECT
    id,
    title,
    yr
FROM movie
where title like '%Star Trek%'
order by yr;

/* 4. What id number does the actor 'Glenn Close' have?*/
SELECT
    id
from actor
where name = 'Glenn Close';

/* 5. What is the id of the film 'Casablanca'*/
SELECT
    id
FROM movie
WHERE title = 'Casablanca';

/* 6. Obtain the cast list for 'Casablanca'. */
SELECT
    name
FROM actor
join casting on actor.id = casting.actorid
WHERE casting.movieid=11768;

/* 7. Obtain the cast list for the film 'Alien' */
SELECT
    name
FROM actor
join casting on actor.id = casting.actorid
join movie on movie.id = casting.movieid
WHERE movie.title = 'Alien';

/* 8. List the films in which 'Harrison Ford' has appeared*/
SELECT
    title
FROM movie
join casting on movie.id = casting.movieid
join actor on actor.id = casting.actorid
WHERE actor.name = 'Harrison Ford';

/* 9. List the films where 'Harrison Ford' has appeared - but not in the starring role.
[Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role] */
SELECT
    title
FROM movie
join casting on movie.id = casting.movieid
join actor on actor.id = casting.actorid
WHERE actor.name = 'Harrison Ford' and casting.ord != 1;

/* 10. List the films together with the leading star for all 1962 films. */
SELECT
    title,
    actor.name
FROM actor
join casting on actor.id = casting.actorid
join movie on casting.movieid = movie.id
WHERE yr = 1962 and casting.ord = 1;

/* 11. Which were the busiest years for 'John Travolta',
show the year and the number of movies he made each year for any year in which he made more than 2 movies.*/
SELECT
    yr,
    count(title)
FROM actor
join casting on actor.id = casting.actorid
join movie on casting.movieid = movie.id
WHERE actor.name = 'John Travolta'
GROUP BY yr
HAVING count(title) > 2
order by count(title) desc
limit 1;

/* 12. List the film title and the leading actor for all of the films 'Julie Andrews' played in.*/
SELECT
    title,
    name
FROM actor
join casting on actor.id = casting.actorid
join movie on casting.movieid = movie.id
WHERE movieid in (
    SELECT movieid
    from casting
    join actor on actor.id = casting.actorid
    WHERE actor.name = 'Julie Andrews') and
    casting.ord = 1;

/* 13. Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles. */
SELECT
    name
FROM actor
join casting on actor.id = casting.actorid
WHERE ord =1
GROUP BY name
having count(name) >=30
order by name;

/* 14. List the films released in the year 1978 ordered by the number of actors in the cast, then by title.*/
SELECT
    title,
    count(actorid)
FROM movie
join casting on movie.id = casting.movieid
WHERE yr = 1978
group by title
order by count(actorid) desc ,title;

/* 15. List all the people who have worked with 'Art Garfunkel'.*/
SELECT
    name
FROM actor
join casting on actor.id = casting.actorid
WHERE movieid in (SELECT movieid from casting join actor on casting.actorid = actor.id where actor.name = 'Art Garfunkel') AND
      name != 'ARt Garfunkel';
