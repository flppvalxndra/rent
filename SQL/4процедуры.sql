
CREATE PROC ���������������������
@name VARCHAR(20)
AS
BEGIN
SELECT �����������_�����, �������
FROM ������������
WHERE ������ = 0 and ������������ = @name
END
GO

CREATE PROC �������������������
@name VARCHAR(20)
AS
BEGIN
SELECT �����������_�����, �������
FROM ������������
WHERE ������ = 1  and ������������ = @name
END
GO

CREATE PROC ����������������������
AS
BEGIN
SELECT �.������������, COUNT(�.������������) as [����������], SUM(�.������) as [���������� � ������],
       COUNT(�.������������) - SUM(�.������) as [��������]
FROM ������������ � left join ��������� � on �.������������ =�.������������  
GROUP BY  �.������������;
END

-- EXEC ��������������������� '������ ����'
-- EXEC ���������������������� 
 