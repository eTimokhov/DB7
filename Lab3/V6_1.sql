--a) добавьте в таблицу dbo.Person поле EmailAddress типа nvarchar размерностью 50 символов;
ALTER TABLE dbo.Person
ADD EmailAddress NVARCHAR(50);

--b) объявите табличную переменную с такой же структурой как dbo.Person и заполните ее данными из dbo.Person. Поле EmailAddress заполните данными из Person.EmailAddress;
DECLARE @Person TABLE(
	BusinessEntityID INT NOT NULL,
	PersonType NCHAR(2) NOT NULL,
	NameStyle BIT NOT NULL,
	Title NVARCHAR(4) NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	MiddleName NVARCHAR(50),
	LastName NVARCHAR(50) NOT NULL,
	Suffix NVARCHAR(10),
	EmailPromotion INT NOT NULL,
	ModifiedDate DATETIME NOT NULL,
	EmailAddress NVARCHAR(50),
	PRIMARY KEY (BusinessEntityID, PersonType)
);
INSERT INTO @Person (
	BusinessEntityID,
	PersonType,
	NameStyle,
	Title,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion,
	ModifiedDate,
	EmailAddress
)
SELECT
	p.BusinessEntityID,
	p.PersonType,
	p.NameStyle,
	p.Title,
	p.FirstName,
	p.MiddleName,
	p.LastName,
	p.Suffix,
	p.EmailPromotion,
	p.ModifiedDate,
	ea.EmailAddress
FROM dbo.Person p
JOIN Person.EmailAddress ea ON p.BusinessEntityID = ea.BusinessEntityID;

--c) обновите поле EmailAddress в dbo.Person данными из табличной переменной, убрав из адреса все встречающиеся нули;
UPDATE dbo.Person
SET dbo.Person.EmailAddress = REPLACE(p.EmailAddress, '0', '')
FROM @Person p
WHERE p.BusinessEntityID = dbo.Person.BusinessEntityId;

--d) удалите данные из dbo.Person, для которых тип контакта в таблице PhoneNumberType равен ‘Work’;
DELETE p
FROM dbo.Person p
JOIN Person.PersonPhone pp ON p.BusinessEntityID = pp.BusinessEntityID
JOIN Person.PhoneNumberType pnt ON pp.PhoneNumberTypeID = pnt.PhoneNumberTypeID
WHERE pnt.Name = 'Work';

--e) удалите поле EmailAddress из таблицы, удалите все созданные ограничения и значения по умолчанию.
ALTER TABLE dbo.Person DROP COLUMN EmailAddress
ALTER TABLE dbo.Person DROP CONSTRAINT PK_Person
ALTER TABLE dbo.Person DROP CONSTRAINT CHK_Person_PersonType
ALTER TABLE dbo.Person DROP CONSTRAINT DF_Person_Title

--f) удалите таблицу dbo.Person.
DROP TABLE dbo.Person;