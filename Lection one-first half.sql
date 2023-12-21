ALTER TABLE [Minions]
ADD [TownId] INT FOREIGN KEY REFERENCES [Towns]([Id]) NOT NULL

GO

INSERT INTO [Towns]([Id], [Name])
	VALUES
(1,'Sofia '),
(2,'Plovdiv'),
(3,'Varna')

INSERT INTO [Minions]([Id],[Name],[Age],[TownId])
	VALUES
(1,'Kevin',22,1),
(2,'Bob',15,3),
(3,'Steward',NULL,2)

SELECT * FROM [Towns]
SELECT * FROM [Minions]

TRUNCATE TABLE [Minions]

DROP TABLE [Minions]

DROP TABLE [Towns]

CREATE TABLE [People] (
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(200) NOT NULL,
	[Picture] VARBINARY(MAX),
	CHECK (DATALENGTH([Picture]) <= 2000000),
	[Height] DECIMAL(3,2),
	[Weight] DECIMAL(5,2),
	[Gender] CHAR(1) NOT NULL,
	CHECK ([Gender]='m' OR [Gender]='f'),
	[Birthdate] DATE NOT NULL,
	[Biography] NVARCHAR(MAX)
)

INSERT INTO [People]([Name],[Height],[Weight],[Gender],[Birthdate])
	VALUES
('Pesho',1.77,75.2,'m','1998-05-25'),
('Gosho',NULL,NULL,'m','1977-11-05'),
('Maria',1.65,1.42,'f','1998-06-27'),
('Viki',NULL,NULL,'f','1986-02-02'),
('Vancho',1.69,77.8,'m','1999-03-03')

SELECT * FROM People

CREATE TABLE [Users](
	[Id] INT PRIMARY KEY IDENTITY,
	[Username] VARCHAR(30) NOT NULL,
	[Password] VARCHAR(26) NOT NULL,
	[ProfilePicture] VARBINARY(900),
	[LastLoginTime] DATETIME2,
	[IsDeleted] VARCHAR(5) NOT NULL,
	CHECK ([IsDeleted]='true'OR[IsDeleted]='false')
)

INSERT INTO [Users]([Username],[Password],[IsDeleted])
	VALUES
('Pesho','pesho123','false'),
('Gosho','gosho','false'),
('Maria','maria','true'),
('Viki','pasp21','false'),
('Vancho','sashko321','false')

ALTER TABLE [Users]
DROP CONSTRAINT PK__Users__3214EC07AD83745E;

ALTER TABLE [Users]
ADD CONSTRAINT PK_Id_Username PRIMARY KEY (Id,Username);

SELECT * FROM [Users]

ALTER TABLE [Users]
ADD CHECK (DATALENGTH([Password])>=5)