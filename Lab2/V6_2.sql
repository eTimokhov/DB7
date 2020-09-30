--a) создайте таблицу dbo.Person с такой же структурой как Person.Person, кроме полей xml, uniqueidentifier, не включая индексы, ограничения и триггеры;
CREATE TABLE dbo.Person (
	BusinessEntityId INT NOT NULL,
	PersonType NCHAR(2) NOT NULL,
	NameStyle BIT NOT NULL,
	Title NVARCHAR(8) NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	MiddleName NVARCHAR(50) NULL,
	LastName NVARCHAR(50) NOT NULL,
	Suffix NVARCHAR(10) NULL,
	EmailPromotion INT NOT NULL,
	ModifiedDate DATETIME NOT NULL
);

--b) используя инструкцию ALTER TABLE, создайте для таблицы dbo.Person составной первичный ключ из полей BusinessEntityID и PersonType;
ALTER TABLE dbo.Person
ADD CONSTRAINT PK_Person PRIMARY KEY (BusinessEntityID, PersonType);

--c) используя инструкцию ALTER TABLE, создайте для таблицы dbo.Person ограничение для поля PersonType, чтобы заполнить его можно было только значениями из списка ‘GC’,’SP’,’EM’,’IN’,’VC’,’SC’;
ALTER TABLE dbo.Person
ADD CONSTRAINT CHK_Person_PersonType CHECK (PersonType IN ('GC','SP','EM','IN','VC','SC'));

--d) используя инструкцию ALTER TABLE, создайте для таблицы dbo.Person ограничение DEFAULT для поля Title, задайте значение по умолчанию ‘n/a’;
ALTER TABLE dbo.Person
ADD CONSTRAINT DF_Person_Title DEFAULT 'n/a' FOR Title;

--e) заполните таблицу dbo.Person данными из Person.Person только для тех лиц, для которых тип контакта в таблице ContactType определен как ‘Owner’. Поле Title заполните значениями по умолчанию;
INSERT INTO dbo.Person (
	BusinessEntityID, 
	PersonType, 
	NameStyle, 
	FirstName, 
	MiddleName, 
	LastName, 
	Suffix,
	EmailPromotion, 
	ModifiedDate
)
SELECT 
	p.BusinessEntityID,
	p.PersonType,
	p.NameStyle,
	p.FirstName,
	p.MiddleName,
	p.LastName,
	p.Suffix,
	p.EmailPromotion,
	p.ModifiedDate
FROM Person.Person p
INNER JOIN Person.BusinessEntityContact bec ON p.BusinessEntityID = bec.PersonID
INNER JOIN Person.ContactType ct ON bec.ContactTypeID = ct.ContactTypeID
WHERE ct.Name = 'Owner';

--f) измените размерность поля Title, уменьшите размер поля до 4-ти символов, также запретите добавлять null значения для этого поля.
ALTER TABLE dbo.Person
ALTER COLUMN Title NVARCHAR(4) NOT NULL;