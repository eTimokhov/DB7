--a) выполните код, созданный во втором задании второй лабораторной работы. Добавьте в таблицу dbo.Person поля TotalGroupSales MONEY и SalesYTD MONEY. Также создайте в таблице вычисляемое поле RoundSales, округляющее значение в поле SalesYTD до целого числа.
ALTER TABLE dbo.Person
ADD TotalGroupSales MONEY, SalesYTD MONEY, RoundSales AS ROUND(SalesYTD, 0);

--b) создайте временную таблицу #Person, с первичным ключом по полю BusinessEntityID. Временная таблица должна включать все поля таблицы dbo.Person за исключением поля RoundSales.
CREATE TABLE dbo.#Person (
	BusinessEntityID INT NOT NULL,
	PersonType NCHAR(2) NOT NULL,
	NameStyle BIT NOT NULL,
	Title NVARCHAR(4) NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	MiddleName NVARCHAR(50) NULL,
	LastName NVARCHAR(50) NOT NULL,
	Suffix NVARCHAR(10) NULL,
	EmailPromotion INT NOT NULL,
	ModifiedDate DATETIME NOT NULL,
	TotalGroupSales MONEY,
	SalesYTD MONEY
	PRIMARY KEY (BusinessEntityID)
);

--c) заполните временную таблицу данными из dbo.Person. Поле SalesYTD заполните значениями из таблицы Sales.SalesTerritory. Посчитайте общую сумму продаж (SalesYTD) для каждой группы территорий (Group) в таблице Sales.SalesTerritory и заполните этими значениями поле TotalGroupSales. Подсчет суммы продаж осуществите в Common Table Expression (CTE).
WITH SalesCTE AS (SELECT st.[Group], SUM(st.SalesYTD) TotalGroupSales
FROM Sales.SalesTerritory st
GROUP BY st.[Group]
)
INSERT INTO dbo.#Person (
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
	TotalGroupSales,
	SalesYTD
) SELECT
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
	t.TotalGroupSales,
	st.SalesYTD
FROM dbo.Person p
JOIN Sales.Customer c ON p.BusinessEntityID = c.PersonID
JOIN Sales.SalesTerritory st ON c.TerritoryID = st.TerritoryID
JOIN SalesCTE t ON st.[Group] = t.[Group];

--d) удалите из таблицы dbo.Person строки, где EmailPromotion = 2
DELETE FROM dbo.Person WHERE EmailPromotion = 2;

--e) напишите Merge выражение, использующее dbo.Person как target, а временную таблицу как source. Для связи target и source используйте BusinessEntityID. Обновите поля TotalGroupSales и SalesYTD, если запись присутствует в source и target. Если строка присутствует во временной таблице, но не существует в target, добавьте строку в dbo.Person. Если в dbo.Person присутствует такая строка, которой не существует во временной таблице, удалите строку из dbo.Person.
MERGE INTO dbo.Person targ
USING dbo.#Person src
ON targ.BusinessEntityID = src.BusinessEntityID
WHEN MATCHED THEN UPDATE SET
	targ.TotalGroupSales = src.TotalGroupSales,
	targ.SalesYTD = src.SalesYTD
WHEN NOT MATCHED BY TARGET THEN	INSERT(
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
	TotalGroupSales,
	SalesYTD
	)
VALUES(
	src.BusinessEntityID,
	src.PersonType,
	src.NameStyle,
	src.Title,
	src.FirstName,
	src.MiddleName,
	src.LastName,
	src.Suffix,
	src.EmailPromotion,
	src.ModifiedDate,
	src.TotalGroupSales,
	src.SalesYTD
	)
WHEN NOT MATCHED BY SOURCE THEN DELETE;