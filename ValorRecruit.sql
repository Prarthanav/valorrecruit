CREATE TABLE Organization(OrgName varchar(255) NOT NULL, Location Varchar (255), Games Varchar(255), PRIMARY KEY (OrgName));
CREATE TABLE Team(TeamID Varchar(255) NOT NULL,OrgName varchar(255), PRIMARY KEY(TeamID),TeamRegion Varchar (255), FOREIGN KEY(OrgName) REFERENCES Organization(OrgName));
CREATE TABLE LeaderboardStatistics(LBRank int NOT NULL, Region Varchar(255), PRIMARY KEY (LBRank));
CREATE TABLE InGameStatistics(IGRank int NOT NULL, HeadshotPer float, WinPer float, KillVsDeath float,ACS float, PRIMARY KEY (IGRank));
CREATE TABLE Player(PlayerID Varchar(255) NOT NULL,TeamID Varchar(255), IGRank int,LBRank int, PRIMARY KEY(PlayerID),FOREIGN KEY(TeamID) REFERENCES Team(TeamID), FOREIGN KEY(IGRank) REFERENCES InGameStatistics(IGRank), FOREIGN KEY(LBRank) REFERENCES LeaderboardStatistics(LBRank));
CREATE TABLE Weapons(Weapon Varchar(255) NOT NULL,PRIMARY KEY(Weapon));
CREATE TABLE Maps(MapName Varchar(255) NOT NULL, PRIMARY KEY(MapName), NoOfSites int);
CREATE TABLE Iterations(MapName Varchar(255) NOT NULL, PRIMARY KEY(MapName),TeamID Varchar(255), FOREIGN KEY(MapName) REFERENCES Maps(MapName),  FOREIGN KEY(TeamID) REFERENCES Team(TeamID));
CREATE TABLE Coach(CoachID int NOT NULL, PRIMARY KEY(CoachID), CoachName Varchar(255), CareerTime int, Position Varchar(255),TeamID Varchar(255),FOREIGN KEY(TeamID) REFERENCES Team(TeamID));
CREATE TABLE AgentClass(AgentClassName Varchar(255) NOT NULL, PRIMARY KEY(AgentClassName));
CREATE TABLE Agents(AgentName Varchar(255) NOT NULL, PRIMARY KEY(AgentName), Ability Varchar(255),AgentClassName Varchar(255), FOREIGN KEY(AgentClassName) REFERENCES AgentClass(AgentClassName));
CREATE TABLE AgentIterations(AgentClassName Varchar(255), MapName Varchar(255), AgentName varchar(255), FOREIGN KEY(MapName) REFERENCES Maps(MapName), FOREIGN KEY(AgentClassName) REFERENCES AgentClass(AgentClassName),FOREIGN KEY(AgentName) REFERENCES Agents(AgentName));
CREATE TABLE TopMaps(MapName Varchar(255),PlayerID Varchar(255),FOREIGN KEY(MapName) REFERENCES Maps(MapName),FOREIGN KEY(PlayerID) REFERENCES Player(PlayerID));
CREATE TABLE TopWeapons(Weapon Varchar(255),PlayerID Varchar(255),FOREIGN KEY(Weapon) REFERENCES Weapons(Weapon), FOREIGN KEY(PlayerID) REFERENCES Player(PlayerID));
CREATE TABLE TopAgents(AgentName Varchar(255), PlayerID Varchar(255),FOREIGN KEY(AgentName) REFERENCES Agents(AgentName),FOREIGN KEY(PlayerID) REFERENCES Player(PlayerID));

-- Simple Query
INSERT Organization VALUES("Riot Games", "West Los Angeles, CA", "Valorant");
INSERT Team VALUES("JudgeJury", "Riot Games", "North America");


INSERT INTO AgentClass (AgentClassName)
VALUES
('Duelist'),
('Initiator'),
('Controller'),
('Sentinel');
INSERT INTO Agents (AgentName, Ability, AgentClassName)
VALUES
  ('Brimstone', 'Stim Beacon', 'Controller'),
  ('Viper', 'Snake Bite', 'Controller'),
  ('Omen', 'Shrouded Step', 'Controller'),
  ('Raze', 'Paint Shells', 'Duelist'),
  ('Cypher', 'Cyber Cage', 'Sentinel'),
  ('Sage', 'Healing Orb', 'Sentinel'),
  ('Sova', 'Owl Drone', 'Initiator'),
  ('Phoenix', 'Blaze', 'Duelist'),
  ('Jett', 'Tailwind', 'Duelist'),
  ('Breach', 'Aftershock', 'Initiator'),
  ('Killjoy', 'Nanoswarm', 'Sentinel'),
  ('Reyna', 'Leer', 'Duelist'),
  ('Skye', 'Trailblazer', 'Initiator'),
  ('Yoru', 'Fakeout', 'Duelist'),
  ('Astra', 'Nova Pulse', 'Controller');

SELECT PlayerID,AgentName FROM TopAgents
WHERE AgentName = "Brimstone";

-- Aggregate Query 
SELECT AVG(HeadshotPer) FROM InGameStatistics;

-- Inner Join
SELECT Player.PlayerID, Player.TeamID, Team.TeamRegion
FROM Player
INNER JOIN Team ON Player.TeamID = Team.TeamID;


-- Nested Query
SELECT OrgName, Location
FROM Organization
WHERE OrgName IN (SELECT OrgName FROM Team WHERE TeamRegion = 'North America');

-- Correlated Query
SELECT PlayerID, IGRank
FROM Player p1
WHERE IGRank > (SELECT AVG(p2.IGRank) FROM Player p2 WHERE p1.TeamID = p2.TeamID);

-- Example with <=
SELECT PlayerID, IGRank
FROM Player
WHERE IGRank <= ANY(SELECT IGRank FROM Player WHERE IGRank < 10);

-- Set Operations
SELECT PlayerID FROM Player WHERE TeamID IS NOT NULL
UNION
SELECT PlayerID FROM TopMaps WHERE MapName = 'Pearl';


-- Subqueries in Select and From
SELECT TeamID, AVG(KillVsDeath) AS AvgKillVsDeath
FROM (SELECT Player.TeamID, InGameStatistics.KillVsDeath
      FROM Player
      JOIN InGameStatistics ON Player.IGRank = InGameStatistics.IGRank) AS Subquery
GROUP BY TeamID;

-- Additional 
UPDATE Player
SET TeamID = NULL
WHERE TeamID = 'JudgeJury';

SELECT PlayerID
FROM Player
ORDER BY LBRank
LIMIT 5;

UPDATE Coach
SET TeamID = 'JudgeJury'
WHERE CoachName = "Laird Greatreax";

SELECT * FROM Coach;