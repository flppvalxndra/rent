
CREATE PROC СвободноеОборудование
@name VARCHAR(20)
AS
BEGIN
SELECT Инвентарный_номер, Дефекты
FROM Оборудование
WHERE Статус = 0 and Наименование = @name
END
GO

CREATE PROC ОборудованиеВАренде
@name VARCHAR(20)
AS
BEGIN
SELECT Инвентарный_номер, Дефекты
FROM Оборудование
WHERE Статус = 1  and Наименование = @name
END
GO

CREATE PROC КоличествоОборудования
AS
BEGIN
SELECT о.Наименование, COUNT(о.Наименование) as [Количество], SUM(о.Статус) as [Количество в аренде],
       COUNT(о.Наименование) - SUM(о.Статус) as [Свободно]
FROM Оборудование о left join Категория к on к.Наименование =о.Наименование  
GROUP BY  о.Наименование;
END

-- EXEC СвободноеОборудование 'Горные Лыжи'
-- EXEC КоличествоОборудования 
 