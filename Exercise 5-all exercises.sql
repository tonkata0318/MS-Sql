USE Gringotts

SELECT TOP(2) DepositGroup
FROM  WizzardDeposits 
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize) 


SELECT DepositGroup,SUM(DepositAmount) 
FROM WizzardDeposits
WHERE MagicWandCreator='Ollivander family'
GROUP BY DepositGroup

SELECT DepositGroup,SUM(DepositAmount) 
FROM WizzardDeposits
WHERE MagicWandCreator='Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount)<150000
ORDER BY SUM(DepositAmount) DESC

SELECT DepositGroup,MagicWandCreator,MIN(DepositCharge) AS MinDepositCharge
FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY MagicWandCreator,MIN(DepositGroup) ASC 

SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS MinDepositCharge FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup

SELECT Age,COUNT(*) AS WizardCount
FROM WizzardDeposits
GROUP BY Age

SELECT [AgeGroups],COUNT(*) FROM
	(SELECT FirstName,Age,
		CASE
			WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
			WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
			WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
			WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
			WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
			WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
			ELSE '[61+]'
		END AS [AgeGroups]
	FROM WizzardDeposits) AS [AgeGrouped]
GROUP BY AgeGroups

SELECT * FROM(
SELECT SUBSTRING(FirstName, 1, 1) AS FirstLetter 
FROM WizzardDeposits
WHERE DepositGroup='Troll Chest') AS FirstQuery
GROUP BY FirstLetter
ORDER BY FirstLetter

SELECT DepositGroup,IsDepositExpired,AVG(DepositInterest) AS AverageInterest
FROM WizzardDeposits
WHERE DepositStartDate>'1.01.1985'
GROUP BY DepositGroup,[IsDepositExpired]
ORDER BY DepositGroup DESC,IsDepositExpired

USE SoftUni

SELECT DepartmentID,SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

SELECT DepartmentID,MIN(Salary) AS MinimumSalary
FROM Employees
WHERE DepartmentID IN (2,5,7) AND HireDate>'1.01.2000'
GROUP BY DepartmentID
ORDER BY DepartmentID

SELECT * INTO EmployeesNew
FROM Employees
WHERE Salary>30000

DELETE
FROM EmployeesNew
WHERE ManagerID=42

UPDATE EmployeesNew
SET Salary=Salary+5000
WHERE DepartmentID=1

SELECT DepartmentID,AVG(Salary) as AverageSalary
FROM EmployeesNew
GROUP BY DepartmentID


SELECT * FROM
	(SELECT DepartmentID,MAX(Salary) AS MaxSalary
	FROM Employees
	GROUP BY DepartmentID) AS FirstQyery
WHERE MaxSalary<30000 OR MaxSalary>70000


SELECT Count(*) AS [Count] FROM Employees
WHERE ManagerID IS NULL

SELECT DepartmentID,Salary FROM
(SELECT Salary,DepartmentID,MAX(Salary) AS MaxSalary,
DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRanking
FROM Employees
GROUP BY DepartmentID,Salary) as subq
WHERE subq.SalaryRanking=3


