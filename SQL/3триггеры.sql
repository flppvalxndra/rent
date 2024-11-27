-- Процедура вычисления скидки чека
CREATE TRIGGER СкидкаКлиента ON Чек
AFTER INSERT
AS
BEGIN
	IF ((SELECT [Сумма выкупа] FROM view_clientS WHERE ID_карты = (SELECT ID_карты from inserted)) >= 30000.0
	   OR (SELECT [Количество оборудования] FROM view_clientN WHERE ID_карты = (SELECT ID_карты from inserted)) >= 30)
	   UPDATE Чек SET Скидка = 0.25 WHERE Номер = (SELECT Номер FROM inserted) and Дата = (SELECT Дата FROM inserted)
ELSE
	IF ((SELECT [Сумма выкупа] FROM view_clientS WHERE ID_карты = (SELECT ID_карты from inserted)) >= 20000.0
	   OR (SELECT [Количество оборудования] FROM view_clientN WHERE ID_карты = (SELECT ID_карты from inserted)) >= 20)
	   UPDATE Чек SET Скидка = 0.2 WHERE Номер = (SELECT Номер FROM inserted) and Дата = (SELECT Дата FROM inserted)
ELSE
	IF ((SELECT [Сумма выкупа] FROM view_clientS WHERE ID_карты = (SELECT ID_карты from inserted)) >= 15000.0
	   OR (SELECT [Количество оборудования] FROM view_clientN WHERE ID_карты = (SELECT ID_карты from inserted)) >= 15)
	   UPDATE Чек SET Скидка = 0.1 WHERE Номер = (SELECT Номер FROM inserted) and Дата = (SELECT Дата FROM inserted)
ELSE
	IF ((SELECT [Сумма выкупа] FROM view_clientS WHERE ID_карты = (SELECT ID_карты from inserted)) >= 10000.0
	   OR (SELECT [Количество оборудования] FROM view_clientN WHERE ID_карты = (SELECT ID_карты from inserted)) >= 10)
	   UPDATE Чек SET Скидка = 0.05 WHERE Номер = (SELECT Номер FROM inserted) and Дата = (SELECT Дата FROM inserted)
END;
GO

-- Процедура заполнения чека
-- Проверка свободно ли оборудование + обновление суммы чека + изменение статус инв.оборудование
CREATE TRIGGER ЗаполнениеЧека ON Строка_чека
INSTEAD OF INSERT
AS
BEGIN
IF (SELECT о.Статус FROM  inserted i inner join Оборудование о ON о.Инвентарный_номер = i.Инвентарный_номер) > 0
	BEGIN
	RAISERROR ('Оборудование с данным инвентарным номером еще не возвращено', 16, 1);
	RETURN
	END;

IF (SELECT COUNT(*) FROM чек ч inner join Строка_чека сч on ч.Номер = сч.Номер and ч.Дата = сч.Дата
	WHERE ч.Номер = (SELECT Номер FROM inserted) and ч.Дата = (SELECT Дата FROM inserted)) >= 5
	BEGIN
	RAISERROR ('Максимальное количество оборудования в одном чеке не должно превышать 5 штук', 16, 1);
	RETURN
	END;

INSERT INTO Строка_чека (Инвентарный_номер,Номер,Дата)
SELECT Инвентарный_номер,Номер,Дата FROM inserted;
	
UPDATE Чек
SET Сумма = Сумма + ((SELECT к.Цена_за_час FROM  Оборудование о inner join Категория к ON к.Наименование = о.Наименование 
                    WHERE о.Инвентарный_номер = (SELECT Инвентарный_номер FROM inserted))
		            * (SELECT ч.Срок_аренды FROM Чек ч WHERE Номер = (SELECT Номер FROM inserted) and Дата = (SELECT Дата FROM inserted)))
FROM Чек
WHERE Номер = (SELECT Номер FROM inserted) and Дата = (SELECT Дата FROM inserted);

UPDATE Чек
SET Стоимость_со_скидкой = Сумма * (1.0-Скидка)
FROM Чек
WHERE Номер = (SELECT Номер FROM inserted) and Дата = (SELECT Дата FROM inserted);

UPDATE Чек
SET Залог = Залог + (SELECT к.Цена_за_час FROM  Оборудование о inner join Категория к ON к.Наименование = о.Наименование 
                    WHERE о.Инвентарный_номер = (SELECT Инвентарный_номер FROM inserted))
FROM Чек
WHERE Номер = (SELECT Номер FROM inserted) and Дата = (SELECT Дата FROM inserted);

UPDATE Оборудование
SET Статус = 1
WHERE Инвентарный_номер = (SELECT Инвентарный_номер FROM inserted);

END;
GO

-- Время проката (транзакция)
CREATE TRIGGER ВремяПроката ON Чек
AFTER INSERT
AS
BEGIN
IF (SELECT CAST(DATEADD(hh,Срок_аренды,Дата)AS TIME) from inserted) >= '20:00'
	BEGIN
	RAISERROR ('Предполагаемое  время возврата оборудования превышает время работы точки аренды', 16, 1);
	ROLLBACK TRANSACTION;
	RETURN
	END;
END;
GO