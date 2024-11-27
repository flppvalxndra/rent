CREATE TABLE `Клиенты` (
	`ID_карты` INT NOT NULL AUTO_INCREMENT UNIQUE,
	`Фамилия` varchar NOT NULL,
	`Имя` varchar NOT NULL,
	`Отчество` varchar,
	`Дата` DATE,
	`Телефон` varchar,
	`Почта` varchar,
	PRIMARY KEY (`ID_карты`)
);

CREATE TABLE `Чек` (
	`Номер` INT NOT NULL AUTO_INCREMENT,
	`Дата` DATETIME NOT NULL,
	`ID_карты` INT,
	`Срок_аренды` INT,
	`Залог` FLOAT NOT NULL DEFAULT '0.00',
	`Сумма` FLOAT NOT NULL DEFAULT '0.00',
	`Скидка` FLOAT NOT NULL DEFAULT '0.00',
	`Стоимость_со_скидкой` FLOAT NOT NULL DEFAULT '0.00',
	PRIMARY KEY (`Номер`,`Дата`)
);

CREATE TABLE `Строка_чека` (
	`Номер` INT NOT NULL AUTO_INCREMENT UNIQUE,
	`Дата` DATETIME NOT NULL UNIQUE,
	`Инвентарный_номер` varchar NOT NULL UNIQUE,
	PRIMARY KEY (`Номер`,`Дата`,`Инвентарный_номер`)
);

CREATE TABLE `Оборудование` (
	`Инвентарный_номер` varchar NOT NULL UNIQUE,
	`Дефекты` varchar,
	`Статус` bool NOT NULL DEFAULT '0',
	`Наименование` varchar NOT NULL,
	PRIMARY KEY (`Инвентарный_номер`)
);

CREATE TABLE `Категория` (
	`Наименование` varchar NOT NULL,
	`Цена_за_час` FLOAT,
	PRIMARY KEY (`Наименование`)
);

CREATE TABLE `Возврат` (
	`Номер` INT NOT NULL AUTO_INCREMENT,
	`Время_начала_проката` DATETIME NOT NULL,
	`Время_возврата` DATETIME NOT NULL,
	PRIMARY KEY (`Номер`,`Время_начала_проката`)
);

CREATE TABLE `Доплата` (
	`Номер` INT NOT NULL AUTO_INCREMENT,
	`Время_начала_проката` DATETIME NOT NULL,
	`Сумма` FLOAT,
	PRIMARY KEY (`Номер`,`Время_начала_проката`)
);

ALTER TABLE `Чек` ADD CONSTRAINT `Чек_fk0` FOREIGN KEY (`ID_карты`) REFERENCES `Клиенты`(`ID_карты`);

ALTER TABLE `Строка_чека` ADD CONSTRAINT `Строка_чека_fk0` FOREIGN KEY (`Номер`) REFERENCES `Чек`(`Номер`);

ALTER TABLE `Строка_чека` ADD CONSTRAINT `Строка_чека_fk1` FOREIGN KEY (`Дата`) REFERENCES `Чек`(`Дата`);

ALTER TABLE `Строка_чека` ADD CONSTRAINT `Строка_чека_fk2` FOREIGN KEY (`Инвентарный_номер`) REFERENCES `Оборудование`(`Инвентарный_номер`);

ALTER TABLE `Оборудование` ADD CONSTRAINT `Оборудование_fk0` FOREIGN KEY (`Наименование`) REFERENCES `Категория`(`Наименование`);

ALTER TABLE `Возврат` ADD CONSTRAINT `Возврат_fk0` FOREIGN KEY (`Номер`) REFERENCES `Чек`(`Номер`);

ALTER TABLE `Возврат` ADD CONSTRAINT `Возврат_fk1` FOREIGN KEY (`Время_начала_проката`) REFERENCES `Чек`(`Дата`);

ALTER TABLE `Доплата` ADD CONSTRAINT `Доплата_fk0` FOREIGN KEY (`Номер`) REFERENCES `Возврат`(`Номер`);

ALTER TABLE `Доплата` ADD CONSTRAINT `Доплата_fk1` FOREIGN KEY (`Время_начала_проката`) REFERENCES `Возврат`(`Время_начала_проката`);








