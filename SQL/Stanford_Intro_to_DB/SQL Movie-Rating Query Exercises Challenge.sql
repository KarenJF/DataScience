/* 1. For each movie, return the title and the 'rating spread',
that is, the difference between highest and lowest ratings given to that movie.
Sort by rating spread from highest to lowest, then by movie title. */
SELECT
    title,
    (MAX(stars) - min(stars)) as rating_spread
FROM Movie
Join Rating on Movie.mID = Rating.mID
Group by title
order by rating_spread desc, title;
