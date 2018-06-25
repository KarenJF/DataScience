/* 1. For every situation where student A likes student B,
but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table),
return A and B's names and grades. */
SELECT
    H1.name,
    H1.grade,
    H2.name,
    H2.grade
FROM Highschooler H1
Join Likes L1 on H1.ID = L1.ID1
Join Highschooler H2 on H2.ID = L1.ID2
WHERE H2.ID not in (SELECT ID1 From Likes )

/* 2. For every situation where student A likes student B, but student B likes a different student C,
return the names and grades of A, B, and C. */
SELECT
    H1.name,
    H1.grade,
    H2.name,
    H2.grade,
    H3.name,
    H3.grade
FROM Highschooler H1, Highschooler H2, Highschooler H3, Likes L1, Likes L2
Where H1.ID = L1.ID1 and L1.ID2 = H2.ID and
      H2.ID = L2.ID1 and L2.ID2 = H3.ID and H3.ID <> H1.ID)

/* 3. Find those students for whom all of their friends are in different grades from themselves.
Return the students' names and grades. */
SELECT name, grade
FROM Highschooler H1
WHERE grade NOT IN (
  SELECT H2.grade
  FROM Friend, Highschooler H2
  WHERE H1.ID = Friend.ID1 AND H2.ID = Friend.ID2
);

SELECT name, grade
FROM Highschooler H1
WHERE grade not in (
    SELECT H2.grade from Highschooler H2
    Join Friend on H2.ID = Friend.ID2
    WHERE H1.ID = Friend.ID1
)
