CREATE DATABASE Accounting

USE Accounting

CREATE TABLE Countries(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(10) NOT NULL
)

CREATE TABLE Addresses(
Id INT PRIMARY KEY IDENTITY,
[StreetName] NVARCHAR(20) NOT NULL,
[StreetNumber] INT,
PostCode INT NOT NULL,
City NVARCHAR(25) NOT NULL,
CountryId INT FOREIGN KEY REFERENCES Countries([Id]) NOT NULL
)

CREATE TABLE Vendors(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(25) NOT NULL,
[NumberVAT] NVARCHAR(15) NOT NULL,
AddressId INT FOREIGN KEY REFERENCES Addresses([Id]) NOT NULL
)

CREATE TABLE Clients(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(25) NOT NULL,
[NumberVAT] NVARCHAR(15) NOT NULL,
AddressId INT FOREIGN KEY REFERENCES Addresses([Id]) NOT NULL
)

CREATE TABLE Categories(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(10) NOT NULL,
)

CREATE TABLE Products(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(35) NOT NULL,
Price DECIMAL(18,2) NOT NULL,
CategoryId INT FOREIGN KEY REFERENCES Categories([Id]) NOT NULL,
VendorId INT FOREIGN KEY REFERENCES Vendors([Id]) NOT NULL
)

CREATE TABLE Invoices(
Id INT PRIMARY KEY IDENTITY,
Number INT UNIQUE NOT NULL,
IssueDate DATETIME2 NOT NULL,
DueDate DATETIME2 NOT NULL,
Amount DECIMAL(18,2) NOT NULL,
Currency NVARCHAR(5) NOT NULL,
ClientId INT FOREIGN KEY REFERENCES Clients([Id]) NOT NULL
)

CREATE TABLE ProductsClients(
ProductId INT FOREIGN KEY REFERENCES Products([Id]) NOT NULL,
ClientId INT FOREIGN KEY REFERENCES Clients([Id]) NOT NULL,
PRIMARY KEY(ProductId,ClientId)
)

INSERT INTO Products([Name],[Price],[CategoryId],[VendorId])
VALUES 
('SCANIA Oil Filter XD01',78.69,1,1),
('MAN Air Filter XD01',97.38,1,5),
('DAF Light Bulb 05FG87',55.00,2,13),
('ADR Shoes 47-47.5',49.85,3,5),
('Anti-slip pads S',5.87,5,7)

INSERT INTO Invoices([Number],[IssueDate],[DueDate],[Amount],[Currency],[ClientId])
VALUES
(1219992181,'2023-03-01','2023-04-30', 180.96,'BGN',3),
(1729252340,'2022-11-06','2023-01-04',158.18,'EUR',13),
(1950101013,'2023-02-17','2023-04-18',615.15, 'USD',19)

UPDATE Invoices
SET DueDate = '2023-04-01'
WHERE Year(IssueDate) = 2022 AND Month(IssueDate) = 11

UPDATE Clients
SET AddressId = 3
WHERE [Name] LIKE '%CO%'

DELETE FROM ProductsClients WHERE ClientId = 11
DELETE FROM Invoices WHERE ClientId = 11
DELETE FROM Clients WHERE SUBSTRING(NumberVat, 1, 2) = 'IT'

SELECT [Number],[Currency] FROM Invoices
ORDER BY Amount DESC,DueDate

SELECT p.[Id],p.[Name],[Price],c.Name FROM Products AS p
JOIN Categories AS c ON c.Id=p.CategoryId
WHERE c.Name='ADR' OR c.Name='Others'
ORDER BY Price DESC

SELECT c.Id,c.[Name],CONCAT_WS(', ',CONCAT(a.StreetName,' ',a.StreetNumber),a.City,a.PostCode,co.Name) AS [Address] FROM Clients AS c
LEFT JOIN ProductsClients AS pc ON pc.ClientId=c.Id
LEFT JOIN Addresses AS a ON a.Id=c.AddressId
LEFT JOIN Countries AS co ON co.Id=a.CountryId
WHERE pc.ProductId IS NULL
ORDER BY c.Name

SELECT TOP(7) i.Number,i.Amount,c.[Name] FROM Invoices AS i
LEFT JOIN Clients AS c ON c.Id=i.ClientId
WHERE IssueDate<'2023-01-01' AND i.Currency='EUR' OR i.Amount>500.00 AND SUBSTRING(c.NumberVAT,1,2)='DE'
ORDER BY i.Number,i.Amount DESC


SELECT 
c.Name AS Client,
MAX(p.Price) AS Price,
c.NumberVAT AS [Vat Number]
FROM Clients AS c
	JOIN ProductsClients AS pc ON pc.ClientId=c.Id
	JOIN Products AS p ON p.Id=pc.ProductId
WHERE c.[Name] NOT LIKE '%KG'
GROUP BY c.Name,c.NumberVAT
ORDER BY MAX(p.Price) DESC

SELECT 
	c.Name AS Client,
	FLOOR(AVG(p.Price)) AS [Average Price]
FROM Clients AS c
	JOIN ProductsClients AS pc ON pc.ClientId=c.Id
	JOIN Products AS p ON p.Id=pc.ProductId
	JOIN Vendors AS v ON v.Id=p.VendorId
	WHERE v.NumberVAT LIKE '%FR%'
GROUP BY c.Name
ORDER BY AVG(p.Price) ASC,c.Name DESC

CREATE FUNCTION udf_ProductWithClients(@name NVARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @totalProductsSold INT =
	(
		SELECT COUNT(pc.ClientId)
		FROM ProductsClients AS  pc
		JOIN Products AS p ON p.Id=pc.ProductId
		WHERE p.Name=@name
	)
	RETURN @totalProductsSold
END

CREATE PROCEDURE usp_SearchByCountry
@country VARCHAR(10)
AS

SELECT 
v.[Name] AS Vendor,
v.NumberVAT AS VAT,
CONCAT_WS(' ',a.StreetName,a.StreetNumber) AS [Street Info],
CONCAT_WS(' ',a.City,a.PostCode) AS [City Info]
FROM Vendors AS v
JOIN Addresses AS  a ON a.Id=v.AddressId
JOIN Countries AS c ON c.Id=a.CountryId
WHERE c.Name=@country
ORDER BY v.Name ASC,c.Name ASC

EXEC usp_SearchByCountry 'France'
