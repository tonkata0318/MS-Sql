CREATE DATABASE TouristAgency

USE TouristAgency

CREATE TABLE Countries(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Destinations(
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
CountryId INT FOREIGN KEY REFERENCES Countries([Id]) NOT NULL
)

CREATE TABLE Rooms(
Id INT PRIMARY KEY IDENTITY,
[Type] VARCHAR(40) NOT NULL,
Price DECIMAL(18,2) NOT NULL,
BedCount INT NOT NULL check(BedCount  between 0 and 10),
)

CREATE TABLE Hotels(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) NOT NULL,
DestinationId INT FOREIGN KEY REFERENCES Destinations([Id]) NOT NULL
)

CREATE TABLE Tourists(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(80) NOT NULL,
[PhoneNumber] VARCHAR(20) NOT NULL,
[Email] VARCHAR(80),
CountryId INT FOREIGN KEY REFERENCES Countries([Id]) NOT NULL
)

CREATE TABLE Bookings(
Id INT PRIMARY KEY IDENTITY,
ArrivalDate DATETIME2 NOT NULL,
DepartureDate DATETIME2 NOT NULL,
AdultsCount INT NOT NULL check(AdultsCount  between 1 and 10),
ChildrenCount INT NOT NULL check(ChildrenCount  between 0 and 9),
TouristId INT FOREIGN KEY REFERENCES Tourists([Id]) NOT NULL,
HotelId INT FOREIGN KEY REFERENCES Hotels([Id]) NOT NULL,
RoomId INT FOREIGN KEY REFERENCES Rooms([Id]) NOT NULL
)

CREATE TABLE HotelsRooms(
HotelId INT FOREIGN KEY REFERENCES Hotels([Id]) NOT NULL,
RoomId INT FOREIGN KEY REFERENCES Rooms([Id]) NOT NULL
PRIMARY KEY(HotelId,RoomId)
)


INSERT INTO Tourists([Name],[PhoneNumber],[Email],[CountryId])
VALUES
('John Rivers','653-551-1555','john.rivers@example.com',6),
('Adeline Aglaé','122-654-8726','adeline.aglae@example.com',2),
('Sergio Ramirez','233-465-2876','s.ramirez@example.com',3),
('Johan Müller','322-876-9826','j.muller@example.com',7),
('Eden Smith','551-874-2234','eden.smith@example.com',6)

INSERT INTO Bookings([ArrivalDate],[DepartureDate],[AdultsCount],[ChildrenCount],[TouristId],[HotelId],[RoomId])
VALUES
('2024-03-01','2024-03-11',1,0,21,3,5),
('2023-12-28','2024-01-06',2,1,22,13,3),
('2023-11-15','2023-11-20',1,2,23,19,7),
('2023-12-05','2023-12-09',4,0,24,6,4),
('2024-05-01','2024-05-07',6,0,25,14,6)

UPDATE Bookings
SET DepartureDate=DATEADD(day,1,DepartureDate)
WHERE MONTH(ArrivalDate)=12 AND YEAR(ArrivalDate)=2023

UPDATE Tourists
SET Email=NULL
WHERE [Name] LIKE '%MA%'

DELETE Bookings
WHERE [TouristId]=6 OR [TouristId]=16 OR [TouristId]=25

DELETE Tourists
WHERE [Name] LIKE '%Smith%' 

SELECT CONVERT(varchar, ArrivalDate, 23) AS ArrivalDate,AdultsCount,ChildrenCount 
FROM Bookings AS b
JOIN Rooms AS r ON r.Id=b.RoomId
ORDER BY r.Price DESC,ArrivalDate ASC

SELECT h.Id,h.[Name] FROM Hotels AS h
JOIN HotelsRooms AS hr ON hr.HotelId=h.Id
JOIN Rooms AS r ON r.Id=hr.RoomId
JOIN Bookings AS b ON b.HotelId=h.Id
WHERE r.Type='VIP Apartment'
GROUP BY h.Id,h.Name
ORDER BY COUNT(b.Id) DESC

SELECT t.[Id],t.[Name],t.[PhoneNumber] FROM Tourists AS t
LEFT JOIN Bookings AS b ON b.TouristId=t.Id
LEFT JOIN Hotels AS h ON h.Id=b.HotelId
WHERE h.Id IS NULL
ORDER BY t.[Name] 

SELECT TOP(10) h.[Name],d.[Name],c.[Name] FROM Hotels AS h
JOIN Destinations AS d ON d.Id=h.DestinationId
JOIN Countries AS c ON c.Id=d.CountryId
JOIN Bookings AS b ON b.HotelId=h.Id
WHERE b.ArrivalDate<'2023-12-31' AND h.Id%2!=0
ORDER BY c.[Name] ASC,b.ArrivalDate

SELECT h.[Name],r.Price FROM Tourists AS t
JOIN Bookings AS b ON b.TouristId=t.Id
JOIN Rooms AS r ON r.Id=b.RoomId
JOIN Hotels AS h ON h.Id=b.HotelId
WHERE t.Name NOT LIKE '%EZ' AND h.Id IS NOT NULL
ORDER BY r.Price DESC


/*revenue.
•	Foreach Booking you should join data for the Hotel and the Room, using the Id references;
•	NightsCount – you will need the ArrivalDate and DepartureDate for a DATEDIFF function;
•	Calculate the TotalRevenue by summing the price of each booking, using Price of the Room that is referenced to the specific Booking and multiply it by the NightsCount. 
•	Group all the bookings by HotelName using the reference to the Hotel. 
•	Order the results by TotalRevenue in descending order.

•	HotelName
•	TotalRevenue
*/

SELECT h.[Name],SUM(DATEDIFF(DAY,b.ArrivalDate,b.DepartureDate)*r.Price) AS HotelRevenue FROM Bookings AS b
JOIN Hotels AS h ON h.Id=b.HotelId
JOIN Rooms AS r ON r.Id=b.RoomId
GROUP BY h.[Name]
ORDER BY HotelRevenue DESC



CREATE FUNCTION udf_RoomsWithTourists(@name VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @totalTourists INT=
	(
		SELECT SUM(b.AdultsCount+b.ChildrenCount)
		FROM Tourists AS t
		JOIN Bookings AS b ON b.TouristId=t.Id
		JOIN Rooms AS r ON r.Id=b.RoomId
		WHERE r.Type=@name
	)
	RETURN @totalTourists
END

CREATE OR ALTER PROC usp_SearchByCountry(@country VARCHAR(50)) 
AS
BEGIN
	
	SELECT t.[Name],t.PhoneNumber,t.Email,COUNT(b.Id) AS CountOfBookings FROM Tourists AS t
	JOIN Bookings AS b ON b.TouristId=t.Id
	JOIN Countries AS c ON c.Id=t.CountryId
	JOIN Hotels AS h ON h.Id=b.HotelId
	GROUP BY t.[Name],t.PhoneNumber,t.Email,c.Name
	HAVING c.Name=@country
	ORDER BY t.Name ASC,CountOfBookings DESC

END

EXEC usp_SearchByCountry 'Greece'