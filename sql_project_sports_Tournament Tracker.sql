create database SportsTournament;
use SportsTournament;

create table Teams ( team_id int primary key auto_increment,
team_name varchar(50) not null);

INSERT INTO Teams (team_name) VALUES ('CSK'), ('RCB'), ('DC');
INSERT INTO Teams (team_name) VALUES ('MI'), ('SRH'), ('KKR'), ('PBKS'), ('GT'), ('RR'), ('LSG');

 select * from teams;

create table Players ( player_id int primary key auto_increment,
player_name varchar(50),team_id int, foreign key(team_id) references Teams(team_id));

INSERT INTO Players (player_name, team_id) VALUES 
('Ruturaj Gaikwad', 1), ('MS Dhoni', 1), ('Virat Kohli', 2), ('Faf du Plessis', 2), 
('Rishabh Pant', 3), ('Prithvi Shaw', 3),('Hardik Pandya', 4), ('Suryakumar Yadav', 4),
('Pat Cummins', 5), ('Abhishek Sharma', 5),('Shreyas Iyer', 6), ('Andre Russell', 6),
('Shikhar Dhawan', 7), ('Liam Livingstone', 7),('Shubman Gill', 8), ('Rashid Khan', 8),
('Sanju Samson', 9), ('Jos Buttler', 9),('KL Rahul', 10), ('Marcus Stoinis', 10);

select * from players;

Create table  Matches (
    match_id int primary key auto_increment,
    team1_id INT,
    team2_id INT,
    match_date DATE,
    winner_team_id INT,
    FOREIGN KEY (team1_id) REFERENCES Teams(team_id),
    FOREIGN KEY (team2_id) REFERENCES Teams(team_id),
    FOREIGN KEY (winner_team_id) REFERENCES Teams(team_id)
);

insert into Matches (team1_id, team2_id, match_date, winner_team_id) values
(6, 2, '2025-03-22', 2),(5, 9, '2025-03-23', 5),(1, 4, '2025-03-23', 1),
(10, 3, '2025-03-24', 3),(8, 7, '2025-03-25', 7),(9, 6, '2025-03-25', 6),
(5, 10, '2025-03-26', 10),(2, 1, '2025-03-27', 2),(8, 4, '2025-03-28', 8),
(5, 3, '2025-03-29', 3);

select * from Matches;

CREATE TABLE Stats (
    stat_id INT PRIMARY KEY AUTO_INCREMENT,
    match_id INT,
    player_id INT,
    runs_scored INT,
    wickets_taken INT,
    FOREIGN KEY (match_id) REFERENCES Matches(match_id),
    FOREIGN KEY (player_id) REFERENCES Players(player_id)
);

INSERT INTO Stats (match_id, player_id, runs_scored, wickets_taken) VALUES
(1, 3, 72, 0),(1, 4, 50, 1),(1, 9, 15, 2),(1, 10, 30, 0),
(2, 9, 10, 3),(2, 10, 60, 1),(2, 1, 25, 0),(2, 2, 10, 0),
(3, 1, 45, 0),(3, 2, 30, 1), (3, 7, 28, 2),(3, 8, 35, 0);

select * from stats;

SELECT m.match_id, t.team_name AS winner
FROM Matches m
JOIN Teams t ON m.winner_team_id = t.team_id;

SELECT p.player_name, t.team_name, s.runs_scored, s.wickets_taken
FROM Stats s
JOIN Players p ON s.player_id = p.player_id
JOIN Teams t ON p.team_id = t.team_id;

CREATE VIEW PlayerLeaderboard AS
SELECT p.player_name, SUM(s.runs_scored) AS total_runs
FROM Stats s
JOIN Players p ON s.player_id = p.player_id
GROUP BY s.player_id
ORDER BY total_runs DESC;

CREATE VIEW TeamPoints AS
SELECT t.team_name, COUNT(m.winner_team_id) * 2 AS points
FROM Matches m
JOIN Teams t ON m.winner_team_id = t.team_id
GROUP BY m.winner_team_id;

WITH AvgPerformance AS (
  SELECT p.player_name, AVG(s.runs_scored) AS avg_runs, AVG(s.wickets_taken) AS avg_wickets
  FROM Stats s
  JOIN Players p ON s.player_id = p.player_id
  GROUP BY s.player_id
)
SELECT * FROM AvgPerformance;

SELECT t.team_name, COUNT(m.match_id) AS matches_played,
       SUM(CASE WHEN m.winner_team_id = t.team_id THEN 1 ELSE 0 END) AS matches_won
FROM Teams t
LEFT JOIN Matches m ON t.team_id IN (m.team1_id, m.team2_id)
GROUP BY t.team_id;

