/* 1. The first example shows the goal scored by a player with the last name 'Bender'.
The * says to list all the columns in the table - a shorter way of saying matchid, teamid, player, gtime
Modify it to show the matchid and player name for all goals scored by Germany.
To identify German players, check for: teamid = 'GER' */
SELECT
    matchid,
    player
FROM goal
WHERE teamid = 'GER';

/* 2. From the previous query you can see that Lars Bender's scored a goal in game 1012.
Now we want to know what teams were playing in that match.
Notice in the that the column matchid in the goal table corresponds to the id column in the game table.
We can look up information about game 1012 by finding that row in the game table.
Show id, stadium, team1, team2 for just game 1012 */
SELECT DISTINCT
    id,
    stadium,
    team1,
    team2
FROM goal
join game on goal.matchid = game.id
WHERE goal.matchid = 1012;

/* 3. Modify it to show the player, teamid, stadium and mdate for every German goal.*/
SELECT
    player,
    teamid,
    stadium,
    mdate
FROM goal
join game on goal.matchid = game.id
WHERE goal.teamid = 'GER';

/* 4. Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'*/
SELECT
    team1,
    team2,
    player
FROM goal
join game on goal.matchid = game.id
WHERE player like 'Mario%';

/* 5. The table eteam gives details of every national team including the coach.
You can JOIN goal to eteam using the phrase goal JOIN eteam on teamid=id
Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10 */
SELECT
    player,
    teamid,
    coach,
    gtime
FROM goal
join eteam on goal.teamid = eteam.id
WHERE gtime <=10;

/* 6. To JOIN game with eteam you could use either
game JOIN eteam ON (team1=eteam.id) or game JOIN eteam ON (team2=eteam.id)
List the the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.*/
SELECT
    mdate,
    teamname
FROM game
join eteam on game.team1 = eteam.id
WHERE coach = 'Fernando Santos';

/* 7. List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'*/
SELECT
    player
FROM goal
join game on goal.matchid = game.id
WHERE stadium = 'National Stadium, Warsaw';

/* 8. Instead show the name of all players who scored a goal against Germany.*/
SELECT DISTINCT
    player
FROM goal
join game on goal.matchid = game.id
WHERE teamid != 'GER' and
      (team1 = 'GER' or team2 = 'GER');

/* 9. Show teamname and the total number of goals scored.*/
SELECT
    teamname,
    count(*)
FROM eteam
join goal on eteam.id = goal.teamid
group by teamname;

/* 10. Show the stadium and the number of goals scored in each stadium */
SELECT
    stadium,
    count(*)
FROM game
join goal on game.id = goal.matchid
group by stadium;

/* 11. For every match involving 'POL', show the matchid, date and the number of goals scored.*/
SELECT
    matchid,
    mdate,
    count(*)
FROM game
join goal on game.id = goal.matchid
WHERE team1 = 'POL' or team2 = 'POL'
group by
    matchid,
    mdate;

/* 12. For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'*/
SELECT
    matchid,
    mdate,
    count(matchid)
FROM goal
join game on goal.matchid = game.id
WHERE teamid = 'GER'
GROUP BY
    matchid,
    mdate;

/* 13. List every match with the goals scored by each team as shown.
Sort your result by mdate, matchid, team1 and team2. */
SELECT
    mdate,
    team1,
    SUM((case when teamid = team1 then 1 else 0 end)) as score1,
    team2,
    SUM((case when teamid = team2 then 1 else 0 end)) as score2
FROM game
left join goal on game.id = goal.matchid
group by
    mdate,
    matchid,
    team1,
    team2
Order by mdate, matchid, team1, team2;
