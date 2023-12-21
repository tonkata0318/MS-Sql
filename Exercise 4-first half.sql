USE SoftUni

SELECT Top(5) [EmployeeID],JobTitle,a.AddressID,a.AddressText FROM Employees AS e
JOIN Addresses as a ON a.AddressID=e.AddressID
ORDER BY a.AddressID

SELECT Top(50) [FirstName],[LastName],t.[Name],a.AddressText FROM Employees as e
JOIN Addresses as a ON a.AddressID=e.AddressID
JOIN Towns as t ON a.TownID=t.TownID
ORDER BY [FirstName],[LastName]

SELECT [EmployeeID],[FirstName],[LastName],d.[Name] FROM Employees as e
JOIN Departments as d ON d.DepartmentID=e.DepartmentID
WHERE d.[Name]='Sales'
ORDER BY [EmployeeID]

SELECT TOP (5) [EmployeeID],[FirstName],[Salary],d.[Name] FROM Employees AS e
JOIN Departments as d ON e.DepartmentID=d.DepartmentID
WHERE e.[Salary]>15000
ORDER BY e.DepartmentID

SELECT TOP(3) e.[EmployeeID],[FirstName] FROM Employees AS e
WHERE e.EmployeeID NOT IN 
(SELECT EmployeeID FROM EmployeesProjects)
ORDER BY e.EmployeeID

SELECT [FirstName],[LastName],[HireDate],d.[Name] as [DeptName] FROM Employees as e
JOIN Departments as d ON e.DepartmentID=d.DepartmentID
WHERE e.HireDate>'1.1.1999' 
AND
d.[Name] IN ('Sales','Finance')
ORDER BY e.HireDate 

SELECT TOP (5) e.EmployeeID,FirstName,p.Name AS ProjectName FROM Employees AS e
JOIN EmployeesProjects AS ep ON ep.EmployeeID=e.EmployeeID
JOIN Projects AS p ON p.ProjectID=ep.ProjectID
WHERE p.StartDate>'2002-08-13' 
AND 
p.EndDate IS NULL
ORDER BY e.EmployeeID

USE SoftUni

SELECT e.EmployeeID,FirstName,
	CASE
		WHEN p.StartDate>'2004-12-31' THEN NULL
		ELSE p.Name
	END ProjectName
FROM Employees AS e
JOIN EmployeesProjects AS ep ON ep.EmployeeID=e.EmployeeID
JOIN Projects AS p ON p.ProjectID=ep.ProjectID
WHERE e.EmployeeID=24

SELECT e.EmployeeID,e.FirstName,e.ManagerID,m.FirstName FROM Employees AS e
JOIN Employees m ON e.ManagerID=m.EmployeeID
WHERE e.ManagerID IN (3,7)
ORDER BY EmployeeID

SELECT TOP(50) e.EmployeeID,CONCAT_WS(' ',e.FirstName,e.LastName) EmployeeName,CONCAT_WS(' ',m.FirstName,m.LastName),d.Name AS ManagerName FROM Employees AS e
JOIN Employees m ON e.ManagerID=m.EmployeeID
JOIN Departments d ON d.DepartmentID=e.DepartmentID
ORDER BY e.EmployeeID

SELECT TOP(1) AVG(e.Salary) MinAverageSalary FROM Employees as e
JOIN Departments d ON d.DepartmentID=e.DepartmentID
GROUP BY d.Name
ORDER BY  MinAverageSalary

USE Geography

SELECT c.CountryCode,m.MountainRange,p.PeakName,p.Elevation FROM Countries AS c
JOIN MountainsCountries as mc ON mc.CountryCode=c.CountryCode
JOIN Mountains AS m ON m.Id=mc.MountainId
JOIN Peaks AS p ON p.MountainId=m.Id
WHERE c.CountryCode='BG' AND p.Elevation>2835
ORDER BY p.Elevation DESC

SELECT c.CountryCode,COUNT(m.MountainRange) FROM Countries AS c
JOIN MountainsCountries as mc ON mc.CountryCode=c.CountryCode
JOIN Mountains AS m ON m.Id=mc.MountainId
GROUP BY c.CountryCode HAVING c.CountryCode IN ('BG','RU','US')

SELECT TOP(5) CountryName,r.RiverName FROM Countries AS c
LEFT JOIN CountriesRivers AS cr ON cr.CountryCode=c.CountryCode
LEFT JOIN Rivers AS r ON r.Id=cr.RiverId
WHERE c.ContinentCode='AF'
ORDER BY c.CountryName

SELECT ContinentCode,CurrencyCode,CurrencyUsage FROM
	(SELECT *,
	DENSE_RANK() OVER (PARTITION BY ContinentCode ORDER BY CurrencyUsage DESC) AS CurrencyRank
	FROM
		(SELECT ContinentCode,CurrencyCode,COUNT(CurrencyCode) as CurrencyUsage
		FROM Countries
		GROUP BY ContinentCode,CurrencyCode) AS CoreQuery
	WHERE CurrencyUsage>1) AS SecondSSubQuery
WHERE CurrencyRank=1


SELECT COUNT(*) 
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON mc.CountryCode=c.CountryCode
WHERE mc.MountainId IS NULL

SELECT TOP(5) CountryName,MAX(p.Elevation) AS HighestPeakElevation,MAX(r.Length) AS LongestRiverLength FROM Countries AS c
JOIN MountainsCountries AS mc ON mc.CountryCode=c.CountryCode
JOIN Mountains AS m ON m.Id=mc.MountainId
JOIN Peaks AS p ON p.MountainId=m.Id
JOIN CountriesRivers AS cr ON cr.CountryCode=c.CountryCode
JOIN Rivers AS r ON r.Id=cr.RiverId
GROUP BY CountryName
ORDER BY HighestPeakElevation DESC,LongestRiverLength DESC,CountryName
