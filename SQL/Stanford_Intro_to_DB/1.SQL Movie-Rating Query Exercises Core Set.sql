/* 1. Find the titles of all movies directed by Steven Spielberg. */
SELECT
    m.title
FROM Movie m
WHERE director = 'Steven Spielberg'

/* 2. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. */
SELECT Distinct
    year
FROM Movie
JOIN Rating
ON Movie.mID = Rating.mID
WHERE Rating.stars in (4,5)
order by year

/* 3. Find the titles of all movies that have no ratings. */
SELECT
    title
FROM Movie
LEFT Join Rating on Movie.mID = Rating.mID
WHERE Rating.stars is null

/* 4. Some reviewers didn't provide a date with their rating.
Find the names of all reviewers who have ratings with a NULL value for the date. */
SELECT
    Reviewer.name
FROM Reviewer
Join Rating on Reviewer.rID = Rating.rID
WHERE ratingDate is null

/* 5. Write a query to return the ratings data in a more readable format:
reviewer name, movie title, stars, and ratingDate.
Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. */
SELECT
    name,
    title,
    stars,
    ratingDate
FROM movie
join rating
on movie.mID = rating.mID
join reviewer
on rating.rID = reviewer.rID
group by
    name,
    title,
    stars

/* 6. For all cases where the same reviewer rated the same movie twice
and gave it a higher rating the second time, return the reviewer's name and the title of the movie. */
SELECT name, title
FROM Movie
Join Rating R1 on Movie.mID = R1.mID
Join Rating R2 on Movie.mID = R2.mID
Join Reviewer on R1.rID = Reviewer.rID
WHERE R1.rID = R2.rID and R1.mID = R2.mID and
R1.stars > R2.stars and R1.ratingDate >R2.ratingDate

/* 7. For each movie that has at least one rating, find the highest number of stars that movie received.
Return the movie title and number of stars. Sort by movie title. */
SELECT
    title,
    max(R1.stars)
FROM Movie
Join Rating R1 on Movie.mID = R1.mID
Join Rating R2 on Movie.mID = R2.mID
WHERE R1.mID = R2.mID and
R1.stars >R2.stars
group by title
order by title

/* 8. List movie titles and average ratings, from highest-rated to lowest-rated.
If two or more movies have the same average rating, list them in alphabetical order. */
SELECT
    title,
    avg(stars)
FROM Movie
Join Rating on Movie.mID = Rating.mID
group by title
order by avg(stars) desc, title

/* 9. Find the names of all reviewers who have contributed three or more ratings.
(As an extra challenge, try writing the query without HAVING or without COUNT.) */
SELECT
    name
FROM Rating
Join Reviewer on Rating.rID = Reviewer.rID
group by
    name
Having count(stars) >=3
