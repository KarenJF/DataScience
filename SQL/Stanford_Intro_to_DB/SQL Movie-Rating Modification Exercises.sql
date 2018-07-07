/* 1. Add the reviewer Roger Ebert to your database, with an rID of 209. */
insert into reviewer(rID, name) values (209,'Roger Ebert');

/* 2. Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL. */
insert into Rating(rID, mID, stars,	ratingDate)
    SELECT Reviewer.rID, Movie.mID, 5, null
    FROM Movie
    Left Join Reviewer
    where Reviewer.name = 'James Cameron'

/* 3. For all movies that have an average rating of 4 stars or higher, add 25 to the release year.
(Update the existing tuples; don't insert new tuples.) */
