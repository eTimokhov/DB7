--a) Создайте представление VIEW, отображающее данные из таблиц Person.PhoneNumberType и Person.PersonPhone. Создайте уникальный кластерный индекс в представлении по полям PhoneNumberTypeID и BusinessEntityID.
CREATE VIEW Person.PhoneNumberTypeAndPhoneView (
	BusinessEntityID,
	PhoneNumber,
	PhoneNumberTypeID,
	Name,
	PhoneModifiedDate,
	PhoneNumberTypeModifiedDate
)
WITH SCHEMABINDING
AS SELECT
	pp.BusinessEntityID,
	pp.PhoneNumber,
	pnt.PhoneNumberTypeID,
	pnt.Name,
	pp.ModifiedDate,
	pnt.ModifiedDate
FROM Person.PersonPhone pp
JOIN Person.PhoneNumberType pnt ON pp.PhoneNumberTypeID = pnt.PhoneNumberTypeID

CREATE UNIQUE CLUSTERED INDEX IX_PhoneNumberTypeAndPhoneView_PhoneNumberTypeID_BusinessEntityID
ON Person.PhoneNumberTypeAndPhoneView (PhoneNumberTypeID, BusinessEntityID)


--b) Создайте один INSTEAD OF триггер для представления на три операции INSERT, UPDATE, DELETE. Триггер должен выполнять соответствующие операции в таблицах Person.PhoneNumberType и Person.PersonPhone для указанного BusinessEntityID.
CREATE TRIGGER Person.PhoneNumberTypeAndPhoneViewInsertUpdateDeleteTrigger
ON Person.PhoneNumberTypeAndPhoneView
INSTEAD OF INSERT, UPDATE, DELETE AS
BEGIN
	IF EXISTS (SELECT * FROM inserted)
	BEGIN
		IF EXISTS (SELECT * FROM deleted)
				BEGIN
			UPDATE Person.PhoneNumberType SET
				Name = inserted.Name,
				ModifiedDate = GETDATE()
			FROM inserted, deleted
			WHERE Person.PhoneNumberType.PhoneNumberTypeID = deleted.PhoneNumberTypeID

			UPDATE Person.PersonPhone SET
				BusinessEntityID = inserted.BusinessEntityID,
				PhoneNumber = inserted.PhoneNumber,
				ModifiedDate = GETDATE()
			FROM inserted, deleted
			WHERE Person.PersonPhone.BusinessEntityID = deleted.BusinessEntityID
			AND Person.PersonPhone.PhoneNumber = deleted.PhoneNumber
		END
		ELSE
		BEGIN
			INSERT INTO Person.PhoneNumberType (
				Name,
				ModifiedDate
				)
			SELECT
				inserted.Name,
				GETDATE()
			FROM inserted
			INSERT INTO Person.PersonPhone (
				BusinessEntityID,
				PhoneNumber,
				PhoneNumberTypeID,
				ModifiedDate
				)
			SELECT
				inserted.BusinessEntityID,
				inserted.PhoneNumber,
				pnt.PhoneNumberTypeID,
				GETDATE()
			FROM inserted
			JOIN Person.PhoneNumberType pnt ON inserted.Name = pnt.Name;
		END
	END
	ELSE
	BEGIN
		DELETE FROM Person.PersonPhone
		WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM deleted)
		AND PhoneNumber IN (SELECT PhoneNumber FROM deleted)

		DELETE FROM Person.PhoneNumberType
		WHERE PhoneNumberTypeID IN (SELECT PhoneNumberTypeID FROM deleted)
	END
END;

--c) Вставьте новую строку в представление, указав новые данные для PhoneNumberType и PersonPhone для существующего BusinessEntityID (например 1). Триггер должен добавить новые строки в таблицы Person.PhoneNumberType и Person.PersonPhone. Обновите вставленные строки через представление. Удалите строки.
INSERT INTO Person.PhoneNumberTypeAndPhoneView (
	BusinessEntityID,
	PhoneNumber,
	Name)
VALUES(1, '111-111', 'Cell_1');

UPDATE Person.PhoneNumberTypeAndPhoneView SET
	Name = 'Cell_2',
	PhoneNumber = '222-222'
WHERE PhoneNumber = '111-111';

SELECT * FROM Person.PersonPhone
SELECT * FROM Person.PhoneNumberType

DELETE FROM Person.PhoneNumberTypeAndPhoneView
WHERE PhoneNumber = '222-222';