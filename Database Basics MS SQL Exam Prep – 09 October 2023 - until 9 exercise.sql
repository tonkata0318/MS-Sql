CREATE DATABASE [Boardgames]

USE [Boardgames]



CREATE TABLE Categories(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Addresses(
Id INT PRIMARY KEY IDENTITY,
[StreetName] NVARCHAR(100) NOT NULL,
StreetNumber INT NOT NULL,
Town NVARCHAR(30) NOT NULL,
Country NVARCHAR(50) NOT NULL,
ZIP INT NOT NULL
)

CREATE TABLE Publishers(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(30) NOT NULL,
[AddressId] INT FOREIGN KEY REFERENCES Addresses([Id]) NOT NULL,
Website NVARCHAR(40),
Phone NVARCHAR(20)
)

CREATE TABLE PlayersRanges(
Id INT PRIMARY KEY IDENTITY,
PlayersMin INT NOT NULL,
PlayersMax INT NOT NULL
)

CREATE TABLE Boardgames(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(30) NOT NULL,
YearPublished INT NOT NULL,
Rating DECIMAL NOT NULL,
CategoryId INT FOREIGN KEY REFERENCES Categories([Id]) NOT NULL,
PublisherId INT FOREIGN KEY REFERENCES Publishers([Id]) NOT NULL,
PlayersRangeId INT FOREIGN KEY REFERENCES PlayersRanges([Id]) NOT NULL
)

CREATE TABLE Creators(
Id INT PRIMARY KEY IDENTITY,
[FirstName] NVARCHAR(30) NOT NULL,
[LastName] NVARCHAR(30) NOT NULL,
[Email] NVARCHAR(30) NOT NULL,
)

CREATE TABLE CreatorsBoardgames(
CreatorId INT FOREIGN KEY REFERENCES Creators([Id]) NOT NULL,
BoardgameId INT FOREIGN KEY REFERENCES Boardgames([Id]) NOT NULL,
PRIMARY KEY(CreatorId,BoardgameId)
)

USE [Boardgames]

INSERT INTO Boardgames([Name],[YearPublished],[Rating],[CategoryId],[PublisherId],[PlayersRangeId])
VALUES 
('Deep Blue',2019,5.67,1,15,7),
('Paris',2016,9.78,7,1,5),
('Catan: Starfarers' ,2021, 9.87, 7 ,13, 6),
('Bleeding Kansas',2020,3.25,3,7,4),
('One Small Step',2019,5.75,5,9,2)

INSERT INTO Publishers([Name] ,AddressId ,Website, Phone)
VALUES
('Agman Games',5 ,'www.agmangames.com', '+16546135542'),
('Amethyst Games' ,7, 'www.amethystgames.com', '+15558889992'),
('BattleBooks' ,13 ,'www.battlebooks.com', '+12345678907')

UPDATE PlayersRanges 
SET PlayersMax+=1
WHERE PlayersMax=2 AND PlayersMin=2

UPDATE Boardgames
SET [Name]+='V2'
WHERE [YearPublished]>=2020

DELETE FROM CreatorsBoardgames
WHERE BoardgameId IN (1,16,6,21,31,36,47)

DELETE FROM Boardgames
WHERE PublisherId IN (1,6)

DELETE FROM Publishers
WHERE AddressId=5

DELETE FROM Addresses
WHERE LEFT([Town],1)='L'

USE Boardgames

SELECT b.Id,b.[Name],b.YearPublished,c.Name FROM Boardgames as b
JOIN Categories AS c ON c.Id=b.CategoryId
WHERE c.Name='Wargames' OR c.Name='Strategy Games'
ORDER BY YearPublished DESC

SELECT 
	c.Id
	,CONCAT(c.FirstName, ' ', LastName) AS CreatorName
	,c.Email
FROM  Creators AS c
LEFT JOIN CreatorsBoardgames AS cb
ON c.Id=cb.CreatorId
WHERE cb.CreatorId IS NULL
ORDER BY CreatorName 

SELECT TOP(5) b.[Name],Rating,c.Name AS CategoryName FROM Boardgames as b
LEFT JOIN Categories as c ON c.Id=b.CategoryId
LEFT JOIN PlayersRanges as pr ON pr.Id=b.PlayersRangeId
WHERE b.Rating>7 AND (c.Name LIKE '%a%'
OR b.Rating>7.50) AND pr.PlayersMax<=5 AND pr.PlayersMin>=2
ORDER BY b.Name ASC,b.Rating DESC

SELECT TOP(5)
	c.[Name]
	,Rating
	,cat.[Name] AS CategoryName
FROM Boardgames AS c
LEFT JOIN Categories AS cat
ON c.CategoryId = cat.Id
LEFT JOIN PlayersRanges as r
ON c.PlayersRangeId = r.Id
WHERE Rating > 7
AND (c.[Name] LIKE '%a%'
OR Rating > 7.50)
AND PlayersMin >= 2
AND PlayersMax <= 5
ORDER BY [Name], CategoryName DESC

WITH GamesRankedByCreator AS (
	SELECT 
	CONCAT_WS(' ',c.FirstName,c.LastName) AS FullName,[Email],bg.Rating,bg.[Name],
	RANK() OVER (PARTITION BY Email ORDER BY bg.Rating DESC) as GameRank
	FROM Creators AS c
	JOIN CreatorsBoardgames as cbg ON cbg.CreatorId=c.Id
	JOIN Boardgames as bg ON bg.Id=cbg.BoardgameId
	WHERE RIGHT(Email,4)='.com'
)

SELECT FullName,Email,Rating FROM GamesRankedByCreator
WHERE GameRank=1

SELECT c.LastName,CEILING(AVG(bg.Rating)) as AverageRating,p.[Name] FROM Creators AS c
JOIN CreatorsBoardgames as cbg ON cbg.CreatorId=c.Id
JOIN Boardgames as bg ON bg.Id=cbg.BoardgameId
JOIN Publishers as p ON p.Id=bg.PublisherId
WHERE p.Name='Stonemaier Games'
GROUP BY LastName,p.Name
ORDER BY AVG(bg.Rating) DESC

CREATE FUNCTION udf_CreatorWithBoardgames(@name NVARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @totalGames INT = 
	(
		SELECT COUNT(BoardgameId)
		FROM CreatorsBoardgames AS cbg
		JOIN Creators AS c ON c.Id=cbg.CreatorId
		WHERE c.FirstName=@name
	)
	RETURN @totalGames
END

CREATE PROCEDURE usp_SearchByCategory 
@category nvarchar(30)
AS

DECLARE @categoryId INT =
	(
		SELECT Id
		FROM Categories
		WHERE [Name]=@category
	)

SELECT b.Name,b.YearPublished,b.Rating,@category
,p.[Name] AS [PublisherName]
,CONCAT_WS(' ',pr.PlayersMin,'people') AS MinPlayers
,CONCAT_WS(' ',pr.PlayersMax,'people') AS MaxPlayers
FROM Boardgames AS b
JOIN Publishers AS p ON p.Id=b.PublisherId
JOIN PlayersRanges AS pr ON pr.Id=b.PlayersRangeId
WHERE [CategoryId]=@categoryId
ORDER BY PublisherName,YearPublished DESC
