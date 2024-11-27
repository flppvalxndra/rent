 CREATE DATABASE ������ 
 GO
 USE ������
 
CREATE TABLE �������
( 
	�������              varchar(20)  NULL ,
	���                  varchar(20)  NULL ,
	��������             varchar(20)  NULL ,
	����_��������        date  NULL ,
	�������              varchar(16) NULL ,
	�����������_�����    nvarchar(40)  NULL ,
	ID_�����             integer IDENTITY(1,1) PRIMARY KEY 
)

 CREATE TABLE ���
( 
	�����                integer  IDENTITY(1,1),
	����                 datetime  NOT NULL ,
	����_������          integer  NULL ,
	�����                float DEFAULT 0.00,
	������               float DEFAULT 0.00,
	���������_��_������� float DEFAULT 0.00,
	�����                float DEFAULT 0.00,
	ID_�����             integer  NULL ,
	CONSTRAINT XPK��� PRIMARY KEY  CLUSTERED (����� ASC,���� ASC),
	CONSTRAINT R_11 FOREIGN KEY (ID_�����) REFERENCES �������(ID_�����)
		ON DELETE SET NULL
		ON UPDATE CASCADE
)

CREATE TABLE �������
( 
	�����_��������       datetime NOT NULL ,
	�����                integer  NOT NULL ,
	�����_������_������� datetime  NOT NULL,
	CONSTRAINT XPK������� PRIMARY KEY  CLUSTERED (����� ASC,�����_������_������� ASC),
	CONSTRAINT R_14 FOREIGN KEY (�����,�����_������_�������) REFERENCES ���(�����,����)
		ON DELETE CASCADE
		ON UPDATE CASCADE
)

CREATE TABLE �������
( 
	�����                integer  NOT NULL ,
	�����_������_������� datetime  NOT NULL ,
	�����                float  NULL,
	CONSTRAINT XPK������� PRIMARY KEY  CLUSTERED (����� ASC,�����_������_������� ASC),
	CONSTRAINT R_16 FOREIGN KEY (�����,�����_������_�������) REFERENCES �������(�����,�����_������_�������)
		ON DELETE CASCADE
		ON UPDATE CASCADE
)

CREATE TABLE ���������
( 
	������������         varchar(20)  NOT NULL PRIMARY KEY ,
	����_��_���          float  NULL 
)

CREATE TABLE ������������
( 
	�����������_�����    varchar(5)  NOT NULL PRIMARY KEY,
	�������              varchar(40)  NULL ,
	������������         varchar(20)  NOT NULL ,
	������				 int default 0 CHECK ((������ = 0) or (������=1)),
	CONSTRAINT R_12 FOREIGN KEY (������������) REFERENCES ���������(������������)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
)

CREATE TABLE ������_����
( 
	�����������_�����    varchar(5)  NOT NULL ,
	�����                integer  NOT NULL ,
	����                 datetime  NOT NULL ,
	CONSTRAINT XPK������_���� PRIMARY KEY  CLUSTERED (�����������_����� ASC,����� ASC,���� ASC),
	CONSTRAINT R_5 FOREIGN KEY (�����������_�����) REFERENCES ������������(�����������_�����)
		ON DELETE NO ACTION
		ON UPDATE CASCADE,
	CONSTRAINT R_6 FOREIGN KEY (�����,����) REFERENCES ���(�����,����)
		ON DELETE CASCADE
		ON UPDATE CASCADE
)

-- ������� 
CREATE INDEX Ind_check ON ���(�����, ����)
CREATE INDEX Ind_checkLine ON ������_����(�����������_�����, �����, ����)
CREATE INDEX Ind_client ON �������(ID_�����)
CREATE INDEX Ind_return ON �������(�����)
CREATE INDEX Ind_pay ON �������(�����)