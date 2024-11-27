 CREATE DATABASE Прокат 
 GO
 USE Прокат
 
CREATE TABLE Клиенты
( 
	Фамилия              varchar(20)  NULL ,
	Имя                  varchar(20)  NULL ,
	Отчество             varchar(20)  NULL ,
	Дата_Рождения        date  NULL ,
	Телефон              varchar(16) NULL ,
	Электронная_почта    nvarchar(40)  NULL ,
	ID_карты             integer IDENTITY(1,1) PRIMARY KEY 
)

 CREATE TABLE Чек
( 
	Номер                integer  IDENTITY(1,1),
	Дата                 datetime  NOT NULL ,
	Срок_аренды          integer  NULL ,
	Сумма                float DEFAULT 0.00,
	Скидка               float DEFAULT 0.00,
	Стоимость_со_скидкой float DEFAULT 0.00,
	Залог                float DEFAULT 0.00,
	ID_карты             integer  NULL ,
	CONSTRAINT XPKЧек PRIMARY KEY  CLUSTERED (Номер ASC,Дата ASC),
	CONSTRAINT R_11 FOREIGN KEY (ID_карты) REFERENCES Клиенты(ID_карты)
		ON DELETE SET NULL
		ON UPDATE CASCADE
)

CREATE TABLE Возврат
( 
	Время_возврата       datetime NOT NULL ,
	Номер                integer  NOT NULL ,
	Время_начала_проката datetime  NOT NULL,
	CONSTRAINT XPKВозврат PRIMARY KEY  CLUSTERED (Номер ASC,Время_начала_проката ASC),
	CONSTRAINT R_14 FOREIGN KEY (Номер,Время_начала_проката) REFERENCES Чек(Номер,Дата)
		ON DELETE CASCADE
		ON UPDATE CASCADE
)

CREATE TABLE Доплата
( 
	Номер                integer  NOT NULL ,
	Время_начала_проката datetime  NOT NULL ,
	Сумма                float  NULL,
	CONSTRAINT XPKДоплата PRIMARY KEY  CLUSTERED (Номер ASC,Время_начала_проката ASC),
	CONSTRAINT R_16 FOREIGN KEY (Номер,Время_начала_проката) REFERENCES Возврат(Номер,Время_начала_проката)
		ON DELETE CASCADE
		ON UPDATE CASCADE
)

CREATE TABLE Категория
( 
	Наименование         varchar(20)  NOT NULL PRIMARY KEY ,
	Цена_за_час          float  NULL 
)

CREATE TABLE Оборудование
( 
	Инвентарный_номер    varchar(5)  NOT NULL PRIMARY KEY,
	Дефекты              varchar(40)  NULL ,
	Наименование         varchar(20)  NOT NULL ,
	Статус				 int default 0 CHECK ((Статус = 0) or (Статус=1)),
	CONSTRAINT R_12 FOREIGN KEY (Наименование) REFERENCES Категория(Наименование)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
)

CREATE TABLE Строка_чека
( 
	Инвентарный_номер    varchar(5)  NOT NULL ,
	Номер                integer  NOT NULL ,
	Дата                 datetime  NOT NULL ,
	CONSTRAINT XPKСтрока_чека PRIMARY KEY  CLUSTERED (Инвентарный_номер ASC,Номер ASC,Дата ASC),
	CONSTRAINT R_5 FOREIGN KEY (Инвентарный_номер) REFERENCES Оборудование(Инвентарный_номер)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
	CONSTRAINT R_6 FOREIGN KEY (Номер,Дата) REFERENCES Чек(Номер,Дата)
		ON DELETE CASCADE
		ON UPDATE CASCADE
)

-- ИНДЕКСЫ 
CREATE INDEX Ind_check ON Чек(Номер, Дата)
CREATE INDEX Ind_checkLine ON Строка_чека(Инвентарный_номер, Номер, Дата)
CREATE INDEX Ind_client ON Клиенты(ID_Карты)
CREATE INDEX Ind_return ON Возврат(Номер)
CREATE INDEX Ind_pay ON Доплата(Номер)