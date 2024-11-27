-- ��������� ���������� ������ ����
CREATE TRIGGER ������������� ON ���
AFTER INSERT
AS
BEGIN
	IF ((SELECT [����� ������] FROM view_clientS WHERE ID_����� = (SELECT ID_����� from inserted)) >= 30000.0
	   OR (SELECT [���������� ������������] FROM view_clientN WHERE ID_����� = (SELECT ID_����� from inserted)) >= 30)
	   UPDATE ��� SET ������ = 0.25 WHERE ����� = (SELECT ����� FROM inserted) and ���� = (SELECT ���� FROM inserted)
ELSE
	IF ((SELECT [����� ������] FROM view_clientS WHERE ID_����� = (SELECT ID_����� from inserted)) >= 20000.0
	   OR (SELECT [���������� ������������] FROM view_clientN WHERE ID_����� = (SELECT ID_����� from inserted)) >= 20)
	   UPDATE ��� SET ������ = 0.2 WHERE ����� = (SELECT ����� FROM inserted) and ���� = (SELECT ���� FROM inserted)
ELSE
	IF ((SELECT [����� ������] FROM view_clientS WHERE ID_����� = (SELECT ID_����� from inserted)) >= 15000.0
	   OR (SELECT [���������� ������������] FROM view_clientN WHERE ID_����� = (SELECT ID_����� from inserted)) >= 15)
	   UPDATE ��� SET ������ = 0.1 WHERE ����� = (SELECT ����� FROM inserted) and ���� = (SELECT ���� FROM inserted)
ELSE
	IF ((SELECT [����� ������] FROM view_clientS WHERE ID_����� = (SELECT ID_����� from inserted)) >= 10000.0
	   OR (SELECT [���������� ������������] FROM view_clientN WHERE ID_����� = (SELECT ID_����� from inserted)) >= 10)
	   UPDATE ��� SET ������ = 0.05 WHERE ����� = (SELECT ����� FROM inserted) and ���� = (SELECT ���� FROM inserted)
END;
GO

-- ��������� ���������� ����
-- �������� �������� �� ������������ + ���������� ����� ���� + ��������� ������ ���.������������
CREATE TRIGGER �������������� ON ������_����
INSTEAD OF INSERT
AS
BEGIN
IF (SELECT �.������ FROM  inserted i inner join ������������ � ON �.�����������_����� = i.�����������_�����) > 0
	BEGIN
	RAISERROR ('������������ � ������ ����������� ������� ��� �� ����������', 16, 1);
	RETURN
	END;

IF (SELECT COUNT(*) FROM ��� � inner join ������_���� �� on �.����� = ��.����� and �.���� = ��.����
	WHERE �.����� = (SELECT ����� FROM inserted) and �.���� = (SELECT ���� FROM inserted)) >= 5
	BEGIN
	RAISERROR ('������������ ���������� ������������ � ����� ���� �� ������ ��������� 5 ����', 16, 1);
	RETURN
	END;

INSERT INTO ������_���� (�����������_�����,�����,����)
SELECT �����������_�����,�����,���� FROM inserted;
	
UPDATE ���
SET ����� = ����� + ((SELECT �.����_��_��� FROM  ������������ � inner join ��������� � ON �.������������ = �.������������ 
                    WHERE �.�����������_����� = (SELECT �����������_����� FROM inserted))
		            * (SELECT �.����_������ FROM ��� � WHERE ����� = (SELECT ����� FROM inserted) and ���� = (SELECT ���� FROM inserted)))
FROM ���
WHERE ����� = (SELECT ����� FROM inserted) and ���� = (SELECT ���� FROM inserted);

UPDATE ���
SET ���������_��_������� = ����� * (1.0-������)
FROM ���
WHERE ����� = (SELECT ����� FROM inserted) and ���� = (SELECT ���� FROM inserted);

UPDATE ���
SET ����� = ����� + (SELECT �.����_��_��� FROM  ������������ � inner join ��������� � ON �.������������ = �.������������ 
                    WHERE �.�����������_����� = (SELECT �����������_����� FROM inserted))
FROM ���
WHERE ����� = (SELECT ����� FROM inserted) and ���� = (SELECT ���� FROM inserted);

UPDATE ������������
SET ������ = 1
WHERE �����������_����� = (SELECT �����������_����� FROM inserted);

END;
GO

-- ����� ������� (����������)
CREATE TRIGGER ������������ ON ���
AFTER INSERT
AS
BEGIN
IF (SELECT CAST(DATEADD(hh,����_������,����)AS TIME) from inserted) >= '20:00'
	BEGIN
	RAISERROR ('��������������  ����� �������� ������������ ��������� ����� ������ ����� ������', 16, 1);
	ROLLBACK TRANSACTION;
	RETURN
	END;
END;
GO