USE SoftUni

SELECT [FirstName],[MiddleName],[LastName] FROM Employees

SELECT FirstName+'.'+[LastName]+'@softuni.bg'
AS 'Full Email Address'
FROM [Employees]

SELECT * FROM [Employees]
WHERE [JobTitle]='Sales Representative'

SELECT [FirstName],[LastName],[JobTitle] FROM [Employees]
WHERE [Salary] BETWEEN 20000 AND 30000

SELECT [FirstName]+' '+[MiddleName]+' '+[LastName]
AS [Full Name]
FROM [Employees]
WHERE [Salary] IN (25000, 14000, 12500,23600)

SELECT [FirstName],[LastName] 
FROM [Employees]
WHERE [ManagerID] IS NULL

SELECT [FirstName],[LastName],[Salary]
FROM [Employees]
WHERE [Salary]>50000
ORDER BY [Salary] DESC

SELECT TOP 5 [FirstName],[LastName]
FROM [Employees]
ORDER BY [Salary] DESC

SELECT [FirstName],[LastName]
FROM [Employees]
WHERE [DepartmentID]!=4

SELECT * FROM [Employees]
ORDER BY 
[Salary] DESC,
[FirstName],
[LastName] DESC,
[MiddleName]

CREATE VIEW V_EmployeesSalaries AS
SELECT [FirstName],[LastName],[Salary]
FROM [Employees]

SELECT * FROM V_EmployeesSalaries

CREATE VIEW V_EmployeeNameJobTitl AS
SELECT [FirstName]+' '+[MiddleName] +' '+[LastName] +  ISNULL([MiddleName], '') AS [Full Name],
[JobTitle] 
FROM [Employees]

SELECT * FROM V_EmployeeNameJobTitl

USE [SoftUni]

SELECT DISTINCT [JobTitle] FROM [Employees]

SELECT TOP 10 * FROM [Projects]
WHERE [EndDate] IS NOT NULL
ORDER BY [StartDate],
[Name]

SELECT TOP 7 [FirstName],[LastName],[HireDate] FROM [Employees]
ORDER BY [HireDate] DESC

UPDATE Employees
SET Salary=Salary*1.12
WHERE (JobTitle='Engineering'OR JobTitle='Tool Design'OR JobTitle='Marketing'OR JobTitle='Information Service')

SELECT [Salary] FROM [Employees]

USE [Geography]

SELECT [PeakName] FROM [Peaks]
ORDER BY [PeakName]

SELECT TOP 30 [CountryName],[Population] FROM [Countries]
WHERE [ContinentCode]='EU'
ORDER BY [Population] DESC,
[CountryName]

USE [Diablo]

SELECT [Name] FROM [Characters]
ORDER BY [Name]


USE SoftUni

CREATE VIEW V_EmployeeNameJobTitle AS
SELECT FirstName + ' ' + ISNULL(MiddleName,'')+' '+LastName AS [Employee Name],JobTitle
FROM Employees

UPDATE Employees
SET Salary=Salary*1.12
WHERE DepartmentID IN (1,2,4,11)

SELECT Salary FROM Employees