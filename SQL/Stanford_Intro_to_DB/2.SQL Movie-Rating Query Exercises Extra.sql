/* 1.Find the names of all reviewers who rated Gone with the Wind. */
SELECT distinct
    name
FROM Movie
Join Rating on Movie.mID = Rating.mID
Join Reviewer on Reviewer.rID = Rating.rID
WHERE Movie.title = 'Gone with the Wind'

/* 2. For any rating where the reviewer is the same as the director of the movie,
return the reviewer name, movie title, and number of stars. */
SELECT
    name,
    title,
    stars
FROM Movie
Join Rating on Movie.mID = Rating.mID
Join Reviewer on Reviewer.rID = Rating.rID
WHERE Movie.director = Reviewer.name

/* 3. Return all reviewer names and movie names together in a single list, alphabetized.
(Sorting by the first name of the reviewer and first word in the title is fine;
no need for special processing on last names or removing "The".) */
SELECT title from Movie
UNION
SELECT name from Reviewer
order by name, title;

/* 4. Find the titles of all movies not reviewed by Chris Jackson.*/
SELECT distinct
    title
FROM Movie
WHERE title Not In (

SELECT distinct title
FROM Movie
Join Rating on Movie.mID = Rating.mID
Join Reviewer on Reviewer.rID = Rating.rID
WHERE Reviewer.name = 'Chris Jackson'
)

/* 5. For all pairs of reviewers such that both reviewers gave a rating to the same movie,
return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves,
and include each pair only once. For each pair, return the names in the pair in alphabetical order. */
SELECT distinct
    re1.name, re2.name
FROM Reviewer Re1
Join Rating R1 on Re1.rID = R1.rID
Join Rating R2 on R2.mID = R1.mID
Join Reviewer Re2 on R2.rID = Re2.rID
WHERE re1.name < re2.name
order by re1.name

/* 6. For each rating that is the lowest (fewest stars) currently in the database,
return the reviewer name, movie title, and number of stars. */
SELECT
    name,
    title,
    stars
FROM Movie
Join Rating on Movie.mID = Rating.mID
Join Reviewer on Reviewer.rID = Rating.rID
WHERE stars = (Select min(stars) from Rating)
