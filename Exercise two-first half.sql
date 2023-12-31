CREATE DATABASE [Persons]

USE [Persons]

CREATE TABLE [Persons](
[PersonID] INT PRIMARY KEY IDENTITY,
[FirstName] NVARCHAR(50) NOT NULL,
[Salary] DECIMAL(8,2) NOT NULL,
[PassportID] INT FOREIGN KEY REFERENCES Passports(PassportID)
)

CREATE TABLE [Passports](
[PassportID] INT PRIMARY KEY IDENTITY(101,1),
[PassportNumber] NVARCHAR(50) NOT NULL,
)

INSERT INTO Persons([FirstName],[Salary],[PassportID])
VALUES 
('Roberto',43300.00,102),
('Tom',56100.00,103),
('Yana',60200.00,101)

INSERT INTO Passports(PassportNumber)
VALUES
('N34FG21B'),
('K65LO4R7'),
('ZE657QP2')

ALTER TABLE Persons
ADD UNIQUE(PassportID)

CREATE TABLE Manufacturers(
[ManufacturerID] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50),
[EstablishedOn] DATE
)

INSERT INTO Manufacturers([Name],[EstablishedOn])
VALUES
('BMW','07-03-1916'),
('Tesla','01-01-2003'),
('Lada','01-05-1966')

CREATE TABLE Models(
[ModelID] INT PRIMARY KEY IDENTITY(101,1),
[Name] NVARCHAR(50),
[ManufacturerID] INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)
)

INSERT INTO Models([Name],[ManufacturerID])
VALUES
('X1',1),
('i6',1),
('Model S',2),
('Model X',2),
('Model 3',2),
('Nova',3)

SELECT * FROM Models

CREATE TABLE Students(
[StudentID] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50)
)

INSERT INTO Students([Name])
VALUES
('Mila'),
('Toni'),
('Ron')

CREATE TABLE Exams(
[ExamID] INT PRIMARY KEY IDENTITY(101,1),
[Name] NVARCHAR(50)
)

INSERT INTO Exams([Name])
VALUES
('SpringMVC'),
('Neo4j'),
('Oracle 11g')

CREATE TABLE StudentsExams(
CONSTRAINT PK_StudentExams
PRIMARY KEY(StudentID,ExamID),
[StudentID] INT FOREIGN KEY REFERENCES Students(StudentID),
[ExamID] INT FOREIGN KEY REFERENCES Exams(ExamID),
)

INSERT INTO StudentsExams([StudentID],[ExamID])
VALUES
(1,101),
(1,102),
(2,101),
(3,103),
(2,102),
(2,103)

SELECT * FROM StudentsExams
USE [Persons]

CREATE TABLE Teachers(
[TeacherID] INT PRIMARY KEY IDENTITY(101,1),
[Name] NVARCHAR(50) NOT NULL,
[ManagerID] INT FOREIGN KEY REFERENCES Teachers([TeacherID])
)

INSERT INTO Teachers([Name],[ManagerID])
VALUES
('John',NULL),
('Maya',106),
('Silvia',106),
('Ted',105),
('Mark',101),
('Greta',101)

SELECT * FROM Teachers

TRUNCATE TABLE [Teachers]

CREATE TABLE [Cities](
[CityID] INT PRIMARY KEY,
[Name] NVARCHAR(50)
)




CREATE DATABASE [OnlineStore]

USE [OnlineStore]

CREATE TABLE ItemTypes(
[ItemTypeID] INT PRIMARY KEY,
[Name] NVARCHAR(50)
)

CREATE TABLE [Cities](
[CityID] INT PRIMARY KEY,
[Name] NVARCHAR(50)
)

CREATE TABLE [Items](
[ItemID] INT PRIMARY KEY,
[Name] NVARCHAR(50) NOT NULL,
[ItemTypeID] INT FOREIGN KEY REFERENCES ItemTypes([ItemTypeID])
)

CREATE TABLE Customers(
[CustomerID] INT PRIMARY KEY,
[Name] NVARCHAR(50) NOT NULL,
[Birthday] DATE NOT NULL,
[CityID] INT FOREIGN KEY REFERENCES Cities([CityID])
)

CREATE TABLE Orders(
[OrderID] INT PRIMARY KEY,
[CustomerID] INT FOREIGN KEY REFERENCES Customers([CustomerID])
)

CREATE TABLE [OrderItems](
[OrderID] INT FOREIGN KEY REFERENCES Orders([OrderID]),
[ItemID] INT FOREIGN KEY REFERENCES Items([ItemID])
)

CREATE DATABASE University

USE [University]

CREATE TABLE Majors(
[MajorID] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Subjects(
[SubjectID] INT PRIMARY KEY IDENTITY,
[SubjectName] NVARCHAR(50) NOT NULL
)

CREATE TABLE Students(
[StudentID] INT PRIMARY KEY,
[StudentNumber] INT NOT NULL,
[StudentName] NVARCHAR(50) NOT NULL,
[MajorID] INT FOREIGN KEY REFERENCES Majors([MajorID]) NOT NULL
)

CREATE TABLE Agenda(
[StudentID] INT FOREIGN KEY REFERENCES Students([StudentID]),
[SubjectID] INT FOREIGN KEY REFERENCES Subjects([SubjectID]),
PRIMARY KEY(StudentID,SubjectID)
)

CREATE TABLE Payments(
[PaymentID] INT PRIMARY KEY,
[PaymentDate] DATETIME2,
[PaymentAmount] DECIMAL(8,2),
[StudentID] INT FOREIGN KEY REFERENCES Students([StudentID])
)

USE [Geography]

SELECT m.MountainRange,PeakName,Elevation FROM Peaks AS p
JOIN Mountains AS m on m.Id=p.MountainId
WHERE MountainId=17
ORDER BY Elevation DESC