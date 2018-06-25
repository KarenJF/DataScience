/* 1. Find the names of all students who are friends with someone named Gabriel. */
SELECT
    name
FROM Highschooler
Join Friend on Highschooler.ID = Friend.ID1
WHERE Friend.ID2 in (SELECT distinct ID from Highschooler WHERE name = 'Gabriel')

/* 2. For every student who likes someone 2 or more grades younger than themselves,
return that student's name and grade, and the name and grade of the student they like. */
SELECT
    H1.name,
    H1.grade,
    H2.name,
    H2.grade
From Highschooler H1
Join Likes on H1.ID = Likes.ID1
Join Highschooler H2 on H2.ID = Likes.ID2
WHERE (H1.grade - H2.grade) >= 2

/* 3. For every pair of students who both like each other, return the name and grade of both students.
Include each pair only once, with the two names in alphabetical order. */
SELECT
    H1.name,
    H1.grade,
    H2.name,
    H2.grade
From Highschooler H1
Join Likes L1 on H1.ID = L1.ID1
Join Likes L2 on L1.ID1 = L2.ID2 and L2.ID1 = L1.ID2
Join Highschooler H2 on H2.ID = L2.ID1
WHERE H1.name < H2.name
order by H1.name

/* 4. Find names and grades of students who only have friends in the same grade.
Return the result sorted by grade, then by name within each grade. */
SELECT name, grade
FROM Highschooler H1
WHERE ID NOT IN (
  SELECT ID1
  FROM Friend, Highschooler H2
  WHERE H1.ID = Friend.ID1 AND H2.ID = Friend.ID2 AND H1.grade <> H2.grade
)
ORDER BY grade, name;

/* 5. Find the name and grade of all students who are liked by more than one other student. */
SELECT
    H2.name,
    H2.grade
FROM Highschooler H2
WHERE ID in (

SELECT distinct
    ID2 
FROM Highschooler H1
Join Likes on H1.ID = Likes.ID1
group by ID2
Having count(*)>1
)
