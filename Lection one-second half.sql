USE [SoftUni]

INSERT INTO [Towns] ([Name])
VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas')

INSERT INTO [Department] ([Name])
VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance')

INSERT INTO [Employees] ([FirstName],[MiddleName],[LastName],[JobTitle],[DepartmentId],[HireDate],[Salary])
VALUES
('Ivan','Ivanov','Ivanov','.NET Developer',4,'2013-02-01',3500.00),
('Petar','Petrov','Petrov','Senior Engineer',1,'2004-02-03',4000.00),
('Maria','Petrova','Ivanova','Intern',5,'2016-08-28',525.25),
('Georgi','Teziev','Ivanov','CEO',2,'2007-12-09',3000.00),
('Peter','Pan','Pan','Intern',3,'2016-08-28',599.88)

SELECT * FROM [Towns]

SELECT * FROM [Departments]

SELECT * FROM [Employees]

SELECT * FROM [Towns]
ORDER BY [Name]

SELECT * FROM [Departments]
ORDER BY [Name]

SELECT * FROM [Employees]
ORDER BY [Salary] DESC

SELECT [Name] FROM [Towns]
ORDER BY [Name]

SELECT [Name] FROM [Departments]
ORDER BY [Name]

SELECT [FirstName],[LastName],[JobTitle],[Salary] FROM [Employees]
ORDER BY [Salary] DESC

UPDATE [Employees]
SET Salary=Salary+Salary*0.10

SELECT [Salary] FROM [Employees]

UPDATE [Payments]
SET TaxRate=TaxRate-TaxRate*0.03

SELECT [TaxRate] FROM [Payments]

DELETE FROM [Occupancies]