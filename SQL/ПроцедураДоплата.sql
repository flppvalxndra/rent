-- Доплата

CREATE PROC ВозвратОборудования
@num int,
@date1 datetime, -- Время начала проката
@date2 datetime  -- Время возврата
AS
BEGIN
INSERT INTO Возврат(Время_возврата,Номер,Время_начала_проката)
VALUES (@date2,@num,@date1)
UPDATE Оборудование
SET Статус = 0
FROM Оборудование
WHERE Инвентарный_номер = ANY(SELECT Инвентарный_номер FROM Строка_чека WHERE Номер = @num and Дата = @date1);
	
IF (SELECT DATEADD(mi,10,DATEADD(hh,Срок_аренды,Дата)) FROM Чек WHERE Номер = @num and Дата = @date1) <= @date2
    begin
	DECLARE @pay float = CAST(ROUND(
	                   (DATEDIFF(mi,@date1,@date2) -- в минутах
	                   - (SELECT Срок_аренды*60 FROM Чек WHERE Номер = @num and Дата = @date1))
					   -- цену за час в цену за минуты
					   * (SELECT (Стоимость_со_скидкой/Срок_аренды)/60 FROM Чек WHERE Номер = @num and Дата = @date1)
					   ,2) as decimal(18,2))
	INSERT INTO Доплата(Номер,Время_начала_проката,Сумма)
    VALUES (@num,@date1,@pay)

	SELECT Сумма as [Сумма доплаты]
	FROM Доплата
	WHERE Номер = @num and Время_начала_проката = @date1
	end;
ELSE 
	SELECT 'Оборудование возвращено вовремя' as [Сумма доплаты]

END;



