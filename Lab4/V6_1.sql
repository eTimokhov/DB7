--a) Создайте таблицу Person.PhoneNumberTypeHst, которая будет хранить информацию об изменениях в таблице Person.PhoneNumberType.
--   Обязательные поля, которые должны присутствовать в таблице: ID — первичный ключ IDENTITY(1,1); Action — совершенное действие (insert, update или delete); ModifiedDate — дата и время, когда была совершена операция; SourceID — первичный ключ исходной таблицы; UserName — имя пользователя, совершившего операцию. Создайте другие поля, если считаете их нужными.

CREATE TABLE Person.PhoneNumberTypeHst (
	ID INT IDENTITY(1, 1) PRIMARY KEY,
	Action CHAR(6) NOT NULL CHECK (Action IN('INSERT', 'UPDATE', 'DELETE')),
	ModifiedDate DATETIME NOT NULL,
	SourceID INT NOT NULL,
	UserName VARCHAR(50) NOT NULL
);

--b) Создайте три AFTER триггера для трех операций INSERT, UPDATE, DELETE для таблицы Person.PhoneNumberType. Каждый триггер должен заполнять таблицу Person.PhoneNumberTypeHst с указанием типа операции в поле Action.
CREATE TRIGGER Person.PhoneNumberTypeInsert
ON Person.PhoneNumberType
AFTER INSERT AS
	INSERT INTO Person.PhoneNumberTypeHst([Action], ModifiedDate, SourceID, UserName)
	SELECT 'INSERT', GETDATE(), ins.PhoneNumberTypeID, USER_NAME()
	FROM inserted AS ins;

CREATE TRIGGER Person.PhoneNumberTypeUpdate
ON Person.PhoneNumberType
AFTER UPDATE AS
	INSERT INTO Person.PhoneNumberTypeHst([Action], ModifiedDate, SourceID, UserName)
	SELECT 'UPDATE', GETDATE(), ins.PhoneNumberTypeID, USER_NAME()
	FROM inserted AS ins;

CREATE TRIGGER Person.PhoneNumberTypeDelete
ON Person.PhoneNumberType
AFTER DELETE AS
	INSERT INTO Person.PhoneNumberTypeHst([Action], ModifiedDate, SourceID, UserName)
	SELECT 'DELETE', GETDATE(), del.PhoneNumberTypeID, USER_NAME()
	FROM deleted AS del;

--c) Создайте представление VIEW, отображающее все поля таблицы Person.PhoneNumberType. Сделайте невозможным просмотр исходного кода представления.
CREATE VIEW Person.PhoneNumberTypeView
WITH ENCRYPTION
AS SELECT * FROM Person.PhoneNumberType;

--d) Вставьте новую строку в Person.PhoneNumberType через представление. Обновите вставленную строку. Удалите вставленную строку. Убедитесь, что все три операции отображены в Person.PhoneNumberTypeHst.
INSERT INTO Person.PhoneNumberTypeView (Name, ModifiedDate)
VALUES ('Mobile', GETDATE());

UPDATE Person.PhoneNumberTypeView
SET Name = 'Home_'
WHERE PhoneNumberTypeID = 1;


DELETE FROM Person.PhoneNumberTypeView
WHERE Name = 'Mobile';

SELECT * FROM Person.PhoneNumberTypeHst;
