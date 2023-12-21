USE SoftUni

CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
	SELECT FirstName,LastName FROM Employees
	WHERE Salary>35000

EXEC usp_GetEmployeesSalaryAbove35000

CREATE PROC usp_GetEmployeesSalaryAboveNumber (@number DECIMAL(18,4) = 48100)
AS
	SELECT FirstName,LastName FROM Employees
	WHERE Salary>=@number

EXEC usp_GetEmployeesSalaryAboveNumber

CREATE PROC usp_GetTownsStartingWith (@charName NVARCHAR(10))
AS
	SELECT [Name] FROM Towns
	WHERE [Name] LIKE @charName + '%'

EXEC usp_GetTownsStartingWith 'b'

CREATE PROC usp_GetEmployeesFromTown (@townName NVARCHAR(50))
AS
	SELECT FirstName,LastName FROM Employees AS e
	JOIN Addresses AS a ON e.AddressID=a.AddressID
	JOIN Towns as t ON t.TownID=a.TownID
	WHERE t.Name=@townName

EXEC usp_GetEmployeesFromTown Sofia

CREATE FUNCTION
ufn_GetSalaryLevel(@Salary DECIMAL(18,4))
RETURNS NVARCHAR(10)
AS
BEGIN
	DECLARE @salaryLevel VARCHAR(10)
	IF(@Salary<30000)
		SET @salaryLevel='Low'
	ELSE IF(@Salary<=50000)
		SET @salaryLevel='Average'
	ELSE
		SET @salaryLevel='High'
	RETURN @salaryLevel
END

SELECT dbo.ufn_GetSalaryLevel(25000)


CREATE PROC usp_EmployeesBySalaryLevel (@levelSalary NVARCHAR(10))
AS
	SELECT FirstName,LastName FROM Employees
	WHERE dbo.ufn_GetSalaryLevel(Salary)=@levelSalary

EXEC usp_EmployeesBySalaryLevel 'Low'

CREATE OR ALTER FUNCTION ufn_IsWordComprised(@setOfLetters NVARCHAR(50), @word NVARCHAR(100)) 
RETURNS BIT
AS
BEGIN
	DECLARE @i INT = 1
	WHILE @i <= LEN(@word)
	BEGIN
		DECLARE @ch NVARCHAR(1) = SUBSTRING(@word,@i,1)
		IF CHARINDEX(@ch,@setOfLetters) = 0
			RETURN 0
		ELSE 
			SET @i = @i + 1
	END
	RETURN 1
END

SELECT dbo.ufn_IsWordComprised ('abcd','cabs')

USE Bank

CREATE OR ALTER PROC usp_GetHoldersFullName
AS 
SELECT CONCAT_WS(' ',FirstName,LastName) AS [Full Name] FROM AccountHolders

EXEC usp_GetHoldersFullName

CREATE OR ALTER PROC usp_GetHoldersWithBalanceHigherThan @number numeric
AS
SELECT ah.FirstName,ah.LastName 
FROM AccountHolders as ah
WHERE ah.Id IN (
SELECT AccountHolderId FROM Accounts
GROUP BY AccountHolderId
HAVING SUM(Balance)>@number
)
ORDER BY FirstName,LastName
	
EXEC usp_GetHoldersWithBalanceHigherThan 20000