USE SoftUni

SELECT FirstName,LastName FROM Employees
WHERE NOT JobTitle LIKE '%engineer%'

SELECT [TownID],[Name] FROM Towns
WHERE NOT [Name] LIKE 'R%' AND NOT [Name] LIKE 'B%' AND NOT [Name] LIKE 'D%' 
ORDER BY [Name]

CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT [FirstName],[LastName] FROM Employees
WHERE YEAR(HireDate)>2000

SELECT * FROM V_EmployeesHiredAfter2000

SELECT FirstName,LastName FROM Employees
WHERE LEN(LastName)=5

SELECT EmployeeID,FirstName,LastName,Salary,
DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) as [Rank]
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000
ORDER BY Salary DESC

SELECT * FROM 
	(SELECT EmployeeID,FirstName,LastName,Salary,
	DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) as [Rank]
	FROM Employees
	WHERE Salary BETWEEN 10000 AND 50000) [Subquery]
	WHERE Subquery.[Rank]=2
ORDER BY Salary DESC

USE Geography

SELECT CountryName,IsoCode FROM Countries
WHERE CountryName LIKE '%a%a%a%'
ORDER BY IsoCode

SELECT p.PeakName,r.RiverName,LOWER(LEFT(p.PeakName,LEN(p.PeakName)-1)+r.RiverName) as MIX
FROM Peaks p,Rivers r
WHERE RIGHT(p.PeakName,1)=LEFT(r.RiverName,1)
ORDER BY MIX

USE Diablo

SELECT TOP(50) [Name],FORMAT([Start],'yyyy-MM-dd') Start FROM Games
WHERE Year([Start]) IN (2011,2012)
ORDER BY [Start],[Name]

SELECT [Username],SUBSTRING([Email],CHARINDEX('@',[Email])+1,LEN([Email])) AS [Email Provider] FROM Users
ORDER BY [Email Provider],[Username]

SELECT [Username],[IpAddress] FROM Users
WHERE [IpAddress] LIKE '___.1%.%.___'
ORDER BY [Username]

SELECT [Name] as Game,
	CASE
		WHEN DATEPART(hour,[Start]) BETWEEN 0 AND 11 THEN 'Morning'
		WHEN DATEPART(hour,[Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
		WHEN DATEPART(hour,[Start]) BETWEEN 18 AND 23 THEN 'Evening'
	END [Part of the Day],
	[Duration]=
	CASE 
		WHEN Duration<=3 THEN 'Extra short'
		WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
		WHEN Duration>6 THEN 'Long'
		ELSE 'Extra Long'
	END
FROM Games
ORDER BY [Name],[Duration],[Part of the Day]

USE Orders

SELECT [ProductName],[OrderDate],
	DATEADD(day,3,OrderDate) [Pay Due],
	DATEADD(MONTH,1,OrderDate) [Deliver Due]
FROM Orders