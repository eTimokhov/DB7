-- Вывести значения полей [CreditCardID], [CardType], [CardNumber] из таблицы [Sales].[CreditCard] в виде xml, сохраненного в переменную. Формат xml должен соответствовать примеру.
DECLARE @xml XML;
SET @xml = (
	SELECT CreditCardID AS "@ID", CardType AS "@Type", CardNumber AS "@Number"
	FROM Sales.CreditCard
	FOR XML PATH ('Card'), ROOT ('CreditCards'));
SELECT @xml;
GO

--Создать хранимую процедуру, возвращающую таблицу, заполненную из xml переменной представленного вида. Вызвать эту процедуру для заполненной на первом шаге переменной.
CREATE PROCEDURE dbo.GetCreditCards(@CreditCardsXml XML)
AS
BEGIN
	SELECT 
		x.value('@ID', 'INT') AS CreditCardID,
        x.value('@Type', 'VARCHAR(50)') AS CardType ,
        x.value('@Number', 'VARCHAR(25)') AS CardNumber
    FROM @CreditCardsXML.nodes('/CreditCards/Card') XmlData(x);
END;

DECLARE @xml XML;
SET @xml = (
	SELECT CreditCardID AS "@ID", CardType AS "@Type", CardNumber AS "@Number"
	FROM Sales.CreditCard
	FOR XML PATH ('Card'), ROOT ('CreditCards'));

EXEC dbo.GetCreditCards @xml;