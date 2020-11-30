--Создайте хранимую процедуру, которая будет возвращать сводную таблицу (оператор PIVOT), отображающую данные о количестве сотрудников (HumanResources.Employee) определенного пола, проживающих в каждом городе (Person.Address). Список обозначений для пола передайте в процедуру через входной параметр.

CREATE PROCEDURE dbo.CitiesByGender(@Genders VARCHAR(20)) AS
BEGIN
	EXECUTE('SELECT City, ' + @Genders + '
		FROM (
			SELECT e.BusinessEntityID, e.Gender, a.City
			FROM HumanResources.Employee e
			JOIN Person.BusinessEntityAddress bea on bea.BusinessEntityID = e.BusinessEntityID
			JOIN Person.Address a on a.AddressID = bea.AddressID
		) AS cg
		PIVOT (COUNT(BusinessEntityID) for cg.Gender in(' + @Genders + ')) AS CountOfEmployees');
END;
GO

EXECUTE dbo.CitiesByGender '[F],[M]';