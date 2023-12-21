CREATE DATABASE  NationalTouristSitesOfBulgaria

USE  NationalTouristSitesOfBulgaria

CREATE TABLE Categories(
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Locations(
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
Municipality VARCHAR(50),
Province VARCHAR(50)
)

CREATE TABLE Sites(
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(100) NOT NULL,
LocationId INT FOREIGN KEY REFERENCES Locations([Id]) NOT NULL,
CategoryId INT FOREIGN KEY REFERENCES Categories([Id]) NOT NULL,
Establishment VARCHAR(15)
)

CREATE TABLE Tourists(
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
Age INT NOT NULL check(Age between 0 and 120),
PhoneNumber VARCHAR(20) NOT NULL,
Nationality VARCHAR(30) NOT NULL,
Reward VARCHAR(20)
)

CREATE TABLE SitesTourists(
TouristId INT FOREIGN KEY REFERENCES Tourists([Id]) NOT NULL,
SiteId INT FOREIGN KEY REFERENCES Sites([Id]) NOT NULL,
PRIMARY KEY(TouristId,SiteId)
)

CREATE TABLE BonusPrizes (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE TouristsBonusPrizes(
TouristId INT FOREIGN KEY REFERENCES Tourists([Id]) NOT NULL,
BonusPrizeId INT FOREIGN KEY REFERENCES BonusPrizes([Id]) NOT NULL,
PRIMARY KEY(TouristId,BonusPrizeId)
)

INSERT INTO Tourists([Name],[Age],PhoneNumber,Nationality,Reward)
VALUES
('Borislava Kazakova',52,'+359896354244','Bulgaria',NULL),
('Peter Bosh',48,'+447911844141','UK',NULL),
('Martin Smith',29,'+353863818592','Ireland','Bronze badge'),
('Svilen Dobrev',49,'+359986584786','Bulgaria','Silver badge'),
('Kremena Popova',38,'+359893298604','Bulgaria',NULL)

INSERT INTO Sites([Name],LocationId,CategoryId,[Establishment])
VALUES
('Ustra fortress',90,7,'X'),
('Karlanovo Pyramids',65,7,NULL),
('The Tomb of Tsar Sevt',63,8,'V BC'),
('Sinite Kamani Natural Park',17,1,NULL),
('St. Petka of Bulgaria – Rupite',92,6,'1994')

UPDATE Sites
SET Establishment='(not defined)'
WHERE Establishment IS NULL

SELECT * FROM TouristsBonusPrizes

DELETE FROM TouristsBonusPrizes
WHERE BonusPrizeId=5

DELETE FROM BonusPrizes
WHERE Id=5

SELECT [Name],[Age],[PhoneNumber],Nationality FROM Tourists
ORDER BY Nationality,Age DESC,[Name]

SELECT s.[Name],l.Name,s.Establishment,c.Name FROM Sites AS s
JOIN Locations AS l ON l.Id=s.LocationId
JOIN Categories AS c ON c.Id=s.CategoryId
ORDER BY c.Name DESC ,l.Name ASC,s.Name ASC

SELECT l.Province,l.Municipality,l.Name,COUNT(s.Id) AS CountOfSites FROM Locations AS l
JOIN Sites AS s ON s.LocationId=l.Id
GROUP BY l.Province,l.Municipality,l.Name
HAVING l.Province='Sofia'
ORDER BY CountOfSites DESC,l.Name

SELECT s.[Name],l.Name,l.Municipality,l.Province,s.Establishment FROM Sites AS s
JOIN Locations AS l ON l.Id=s.LocationId
WHERE LEFT(l.Name,1)!='M' AND  LEFT(l.Name,1)!='D' AND LEFT(l.Name,1)!='B' 
AND RIGHT(Establishment,2)='BC'
ORDER BY s.Name

SELECT t.[Name],[Age],[PhoneNumber],[Nationality],
ISNULL(bp.Name, '(no bonus prize)') AS 'BonusPrize'
FROM Tourists AS t
LEFT JOIN TouristsBonusPrizes AS tb ON tb.TouristId=t.Id
LEFT JOIN BonusPrizes AS bp ON bp.Id=tb.BonusPrizeId
ORDER BY t.Name

SELECT SUBSTRING(t.Name, CHARINDEX(' ', t.Name) + 1, LEN(t.Name)) AS [LastName],[Nationality],[Age],[PhoneNumber] FROM Tourists AS t
JOIN SitesTourists as st ON st.TouristId=t.Id
JOIN Sites AS s ON s.Id=st.SiteId
JOIN Categories AS c ON c.Id=s.CategoryId
WHERE c.Name='History and archaeology'
GROUP BY t.Name, t.Nationality, t.Age, t.PhoneNumber
ORDER BY LastName 

CREATE FUNCTION udf_GetTouristsCountOnATouristSite (@Site NVARCHAR(50)) 
RETURNS INT
AS
BEGIN
	DECLARE @Count INT=
	(
		SELECT COUNT(st.TouristId) FROM SitesTourists AS st
		JOIN Sites AS s ON s.Id=st.SiteId
		WHERE s.Name=@Site
	)
	RETURN @Count
END

SELECT dbo.udf_GetTouristsCountOnATouristSite ('Regional History Museum – Vratsa')

CREATE OR ALTER PROCEDURE usp_AnnualRewardLottery
@TouristName NVARCHAR(30)
AS

DECLARE @TouristId INT=
	(
		SELECT Id
		FROM Tourists AS t
		WHERE t.Name=@TouristName
	)

GO
CREATE PROC usp_AnnualRewardLottery(@TouristName VARCHAR(50))
AS
BEGIN
IF (SELECT COUNT(s.Id) FROM Sites AS s
			JOIN SitesTourists AS st ON s.Id = st.SiteId
			JOIN Tourists AS t ON st.TouristId = t.Id
			WHERE t.Name = @TouristName) >= 100
	BEGIN 
			UPDATE Tourists
			SET	Reward = 'Gold badge'
			WHERE Name = @TouristName
	END
ELSE IF (SELECT COUNT(s.Id) FROM Sites AS s
			JOIN SitesTourists AS st ON s.Id = st.SiteId
			JOIN Tourists AS t ON st.TouristId = t.Id
			WHERE t.Name = @TouristName) >= 50
	BEGIN 
			UPDATE Tourists
			SET	Reward = 'Silver badge'
			WHERE Name = @TouristName
	END
ELSE IF (SELECT COUNT(s.Id) FROM Sites AS s
			JOIN SitesTourists AS st ON s.Id = st.SiteId
			JOIN Tourists AS t ON st.TouristId = t.Id
			WHERE t.Name = @TouristName) >= 25
	BEGIN 
			UPDATE Tourists
			SET	Reward = 'Bronze badge'
			WHERE Name = @TouristName
	END
SELECT Name, Reward FROM Tourists
WHERE Name = @TouristName
END

EXEC usp_AnnualRewardLottery 'Gerhild Lutgard'